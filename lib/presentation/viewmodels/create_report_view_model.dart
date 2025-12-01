import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../domain/enums/incident_category.dart';
import '../../domain/enums/incident_status.dart';
import '../../domain/models/incident.dart';
import '../../domain/repositories/i_camera_service.dart';
import '../../domain/repositories/i_incident_repository.dart';
import '../../domain/repositories/i_local_storage_service.dart';
import '../../domain/services/i_report_validator.dart';

class CreateReportViewModel extends ChangeNotifier {
  CreateReportViewModel({
    ICameraService? cameraService,
    ILocalStorageService? localStorageService,
    IReportValidator? reportValidator,
    IIncidentRepository? incidentRepository,
  }) : _camera = cameraService ?? getIt<ICameraService>(),
       _storage = localStorageService ?? getIt<ILocalStorageService>(),
       _validator = reportValidator ?? getIt<IReportValidator>(),
       _repo = incidentRepository ?? getIt<IIncidentRepository>() {
    // Cuando el usuario escribe, recalculamos estado (habilitar botón, etc.)
    descriptionController.addListener(notifyListeners);
  }

  final ICameraService _camera;
  final ILocalStorageService _storage;
  final IReportValidator _validator;
  final IIncidentRepository _repo;

  final TextEditingController descriptionController = TextEditingController();

  // Mantener categorías como texto facilita la UI del Dropdown en esta etapa.
  final List<String> categories = const [
    'Mantenimiento',
    'Seguridad',
    'Limpieza',
    'Infraestructura',
    'Otro',
  ];

  String? selectedCategory;
  String? imagePath; // ruta persistente de la foto
  bool isBusy = false; // cámara / guardado de foto
  bool isSubmitting = false; // envío del formulario

  // El botón Enviar se habilita sólo si pasa la validación de negocio (HU-09).
  bool get canSubmit => _validator
      .validate(description: descriptionController.text, imagePath: imagePath)
      .isValid;

  // Abrir cámara y persistir foto (HU-06 + HU-07).
  Future<void> attachPhoto() async {
    if (isBusy) return;
    isBusy = true;
    notifyListeners();

    try {
      final temp = await _camera.takePicture();
      if (temp == null) return;

      final saved = await _storage.saveImage(temp);
      imagePath = saved.path;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  // Conecta con el repositorio (SQLite) y guarda el incidente (HU-10 + HU-11).
  Future<bool> submit() async {
    // Validación de negocio (desc + foto obligatorias).
    final result = _validator.validate(
      description: descriptionController.text,
      imagePath: imagePath,
    );
    if (!result.isValid) return false;

    isSubmitting = true;
    notifyListeners();

    try {
      final incident = Incident(
        // Si tu modelo genera id en otro lado, podemos dejarlo vacío.
        id: '',
        // Pequeño título derivado para listados (ajústalo cuando definas HU de títulos).
        title: _deriveTitle(descriptionController.text),
        description: descriptionController.text.trim(),
        category: _mapCategory(selectedCategory),
        photoPath: imagePath!, // ya validado arriba
        status: IncidentStatus.pendiente,
        createdAt: DateTime.now(),
      );

      await _repo.createIncident(incident);

      // Limpiar formulario tras guardar.
      descriptionController.clear();
      selectedCategory = null;
      imagePath = null;

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (_) {
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // Mapea el texto del dropdown a tu enum del dominio.
  IncidentCategory _mapCategory(String? name) {
    switch (name) {
      case 'Mantenimiento':
        return IncidentCategory.mobiliario;
      case 'Seguridad':
        return IncidentCategory.seguridad;
      case 'Limpieza':
        return IncidentCategory.limpieza;
      case 'Eléctrico':
        return IncidentCategory.electrico;
      default:
        return IncidentCategory.otro;
    }
  }

  String _deriveTitle(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return 'Reporte';
    return t.length <= 40 ? t : '${t.substring(0, 40)}…';
    // Comentario corto: algo simple para que la tabla tenga un título legible.
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
