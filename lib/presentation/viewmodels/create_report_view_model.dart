import 'dart:io';

import 'package:fix_it_app/core/di/service_locator.dart';
import 'package:fix_it_app/data/services/firebase_storage_service.dart';
import 'package:fix_it_app/domain/enums/incident_area.dart'; // <--- IMPORT
import 'package:fix_it_app/domain/enums/incident_building.dart'; // <--- IMPORT
import 'package:fix_it_app/domain/enums/incident_category.dart';
import 'package:fix_it_app/domain/enums/incident_status.dart';
import 'package:fix_it_app/domain/models/incident.dart';
import 'package:fix_it_app/domain/repositories/i_auth_repository.dart';
import 'package:fix_it_app/domain/repositories/i_camera_service.dart';
import 'package:fix_it_app/domain/repositories/i_incident_repository.dart';
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

  // NUEVOS ESTADOS PARA DROPDOWNS
  IncidentBuilding? selectedBuilding;
  IncidentArea? selectedArea;

  String? _imagePath;
  String? get imagePath => _imagePath;

  bool isBusy = false;
  bool isSubmitting = false;
  String? lastError;

  // ---- Dependencias ----
  final IIncidentRepository _repository;
  final ICameraService? _camera;
  final IAuthRepository _authRepo;
  final FirebaseStorageService _storageService;

  CreateReportViewModel({
    IIncidentRepository? repository,
    ICameraService? camera,
    IAuthRepository? authRepo,
    FirebaseStorageService? storageService,
  }) : _repository = repository ?? getIt<IIncidentRepository>(),
       _camera =
           camera ??
           (getIt.isRegistered<ICameraService>()
               ? getIt<ICameraService>()
               : null),
       _authRepo = authRepo ?? getIt<IAuthRepository>(),
       _storageService = storageService ?? getIt<FirebaseStorageService>();

  // ---- Setters ----
  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  // NUEVOS SETTERS
  void setBuilding(IncidentBuilding? value) {
    selectedBuilding = value;
    notifyListeners();
  }

  void setArea(IncidentArea? value) {
    selectedArea = value;
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

  // Actualizamos la validación para activar el botón Enviar
  bool get canSubmit {
    final descOk = descriptionController.text.trim().isNotEmpty;
    final imgOk = (_imagePath != null && _imagePath!.isNotEmpty);
    final catOk = selectedCategory != null;
    // Nuevas validaciones
    final buildOk = selectedBuilding != null;
    final areaOk = selectedArea != null;

    return descOk && imgOk && catOk && buildOk && areaOk;
  }

  // ---- Adjuntar foto ----
  Future<void> attachPhoto() async {
    if (_camera == null) return;

    isBusy = true;
    notifyListeners();
    try {
      final File? result = await _camera.takePicture();

      if (result != null) {
        _imagePath = result.path;
        notifyListeners();
      }
    } catch (_) {
      // Manejo silencioso
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  // ---- Guardar (LÓGICA ACTUALIZADA) ----
  Future<bool> submit() async {
    final desc = descriptionController.text;
    final localImagePath = _imagePath;
    final userId = _authRepo.currentUserId;

    if (userId == null || !canSubmit) {
      // Doble check de seguridad
      lastError = 'Faltan datos obligatorios o sesión.';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      String remotePhotoUrl = '';

      if (localImagePath != null) {
        final file = File(localImagePath);
        remotePhotoUrl = await _storageService.uploadImage(file, userId);
      }

      final incident = Incident(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: (desc.isEmpty ? 'Reporte' : desc.split('\n').first.trim()),
        description: desc,
        photoPath: remotePhotoUrl,
        category: _mapStringToCategory(selectedCategory),
        status: IncidentStatus.pendiente,
        createdAt: DateTime.now(),
        userId: userId,
        // AGREGAMOS LOS NUEVOS CAMPOS AL OBJETO
        building: selectedBuilding!,
        area: selectedArea!,
      );

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
