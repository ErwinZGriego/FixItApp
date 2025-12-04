import 'dart:io';

import 'package:fix_it_app/core/di/service_locator.dart';
import 'package:fix_it_app/data/services/firebase_storage_service.dart'; // <--- 1. Importar Storage
import 'package:fix_it_app/domain/enums/incident_category.dart';
import 'package:fix_it_app/domain/enums/incident_status.dart';
import 'package:fix_it_app/domain/models/incident.dart';
import 'package:fix_it_app/domain/repositories/i_auth_repository.dart'; // <--- 2. Importar Auth
import 'package:fix_it_app/domain/repositories/i_camera_service.dart';
import 'package:fix_it_app/domain/repositories/i_incident_repository.dart';
import 'package:fix_it_app/domain/services/i_report_validator.dart';
import 'package:flutter/material.dart';

class CreateReportViewModel extends ChangeNotifier {
  // ---- Estado básico de formulario ----
  final TextEditingController descriptionController = TextEditingController();

  final List<String> categories = const [
    'Mobiliario',
    'Infraestructura',
    'Limpieza',
    'Seguridad',
    'Otro',
  ];

  String? selectedCategory;

  String? _imagePath;
  String? get imagePath => _imagePath;

  bool isBusy = false; // Adjuntar foto (cámara/galería)
  bool isSubmitting = false; // Enviar/guardar

  String? lastError;

  // ---- Dependencias ----
  final IIncidentRepository _repository;
  final IReportValidator _validator;
  final ICameraService? _camera;

  // 3. NUEVAS DEPENDENCIAS: Necesitamos saber quién guarda y cómo subir fotos
  final IAuthRepository _authRepo;
  final FirebaseStorageService _storageService;

  CreateReportViewModel({
    IIncidentRepository? repository,
    IReportValidator? validator,
    ICameraService? camera,
    IAuthRepository? authRepo,
    FirebaseStorageService? storageService,
  }) : _repository = repository ?? getIt<IIncidentRepository>(),
       _validator = validator ?? getIt<IReportValidator>(),
       _camera =
           camera ??
           (getIt.isRegistered<ICameraService>()
               ? getIt<ICameraService>()
               : null),
       // Inyectamos Auth y Storage (si no vienen, los pedimos al locator)
       _authRepo = authRepo ?? getIt<IAuthRepository>(),
       _storageService = storageService ?? getIt<FirebaseStorageService>();

  // ---- Setters ----
  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  void setImagePath(String? path) {
    _imagePath = path;
    notifyListeners();
  }

  void setDescription(String text) {
    descriptionController.text = text;
    notifyListeners();
  }

  bool get canSubmit {
    final descOk = descriptionController.text.trim().isNotEmpty;
    final imgOk = (_imagePath != null && _imagePath!.isNotEmpty);
    return descOk && imgOk;
  }

  // ---- Adjuntar foto ----
  Future<void> attachPhoto() async {
    // Si no hay cámara (ej. pruebas), no hacemos nada
    if (_camera == null) return;

    isBusy = true;
    notifyListeners();
    try {
      // El servicio devuelve un objeto File? (o null si cancela)
      final File? result = await _camera.takePicture();

      // Si tomó la foto, guardamos la ruta (path) que es un String
      if (result != null) {
        _imagePath = result.path;
        notifyListeners();
      }
    } catch (_) {
      // Manejo silencioso de errores
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  // ---- Guardar (LÓGICA ACTUALIZADA) ----
  Future<bool> submit() async {
    final desc = descriptionController.text;
    final localImagePath = _imagePath;

    // 4. OBTENER USUARIO: Validamos que haya sesión antes de guardar
    final userId = _authRepo.currentUserId;

    if (userId == null) {
      lastError = 'Error: No hay usuario autenticado.';
      notifyListeners();
      return false;
    }

    // Validar formulario
    final result = _validator.validate(
      description: desc,
      imagePath: localImagePath,
    );
    if (!result.isValid) {
      lastError = 'Faltan datos (descripción o foto).';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      String remotePhotoUrl = '';

      // 5. SUBIR A STORAGE: Si hay foto local, la subimos a la nube
      if (localImagePath != null) {
        final file = File(localImagePath);
        // Esperamos a que Firebase Storage nos de la URL pública (https://...)
        remotePhotoUrl = await _storageService.uploadImage(file, userId);
      }

      // 6. CREAR OBJETO: Usamos la URL remota y el ID del usuario real
      final incident = Incident(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: (desc.isEmpty ? 'Reporte' : desc.split('\n').first.trim()),
        description: desc,
        photoPath: remotePhotoUrl, // <--- ¡Guardamos el link de internet!
        category: _mapStringToCategory(selectedCategory),
        status: IncidentStatus.pendiente,
        createdAt: DateTime.now(),
        userId: userId, // <--- ¡Guardamos el dueño!
      );

      // 7. GUARDAR EN BD
      await _repository.createIncident(incident);
      return true;
    } catch (e) {
      lastError = 'Error al guardar: $e';
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ---- Utilidades ----
  IncidentCategory _mapStringToCategory(String? value) {
    switch (value) {
      case 'Infraestructura':
        return IncidentCategory.infraestructura;
      case 'Limpieza':
        return IncidentCategory.limpieza;
      case 'Mobiliario':
        return IncidentCategory.mobiliario;
      case 'Seguridad':
        return IncidentCategory.seguridad;
      case 'Otro':
      default:
        return IncidentCategory.otro;
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
