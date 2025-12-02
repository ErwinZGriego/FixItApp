// lib/presentation/viewmodels/create_report_view_model.dart
// VM de creación: compatible con CreateReportScreen y con submit() testeable.

import 'dart:io'; // para detectar File y obtener .path

import 'package:fix_it_app/core/di/service_locator.dart';
import 'package:fix_it_app/domain/enums/incident_category.dart';
import 'package:fix_it_app/domain/enums/incident_status.dart';
import 'package:fix_it_app/domain/models/incident.dart';
// Opcional (HU-06): si no está registrado, attachPhoto hace no-op sin romper.
import 'package:fix_it_app/domain/repositories/i_camera_service.dart';
import 'package:fix_it_app/domain/repositories/i_incident_repository.dart';
import 'package:fix_it_app/domain/services/i_report_validator.dart';
import 'package:flutter/material.dart';

class CreateReportViewModel extends ChangeNotifier {
  // ---- Estado básico de formulario ----
  final TextEditingController descriptionController = TextEditingController();

  final List<String> categories = const [
    'mobiliario',
    'infraestructura',
    'limpieza',
  ];

  String? selectedCategory;

  String? _imagePath;
  String? get imagePath => _imagePath;

  bool isBusy = false; // Adjuntar foto (cámara/galería)
  bool isSubmitting = false; // Enviar/guardar

  String? lastError;

  // ---- Dependencias (inyectables en pruebas) ----
  final IIncidentRepository _repository;
  final IReportValidator _validator;
  final ICameraService? _camera;

  CreateReportViewModel({
    IIncidentRepository? repository,
    IReportValidator? validator,
    ICameraService? camera,
  }) : _repository = repository ?? getIt<IIncidentRepository>(),
       _validator = validator ?? getIt<IReportValidator>(),
       _camera =
           camera ??
           (getIt.isRegistered<ICameraService>()
               ? getIt<ICameraService>()
               : null);

  // ---- Setters que la pantalla usa ----
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
    if (_camera == null) {
      return;
    }
    isBusy = true;
    notifyListeners();
    try {
      final result = await _camera.takePicture();
      String? path;

      if (result is String) {
        path = result as String?;
      } else if (result is File) {
        path = result.path;
      } else {
        path = null; // tipo no soportado
      }

      if (path != null && path.trim().isNotEmpty) {
        _imagePath = path;
        notifyListeners();
      }
    } catch (_) {
      // sin prints
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  // ---- Guardar (valida → repo) ----
  Future<bool> submit() async {
    final desc = descriptionController.text;
    final img = _imagePath;

    final result = _validator.validate(description: desc, imagePath: img);
    if (!result.isValid) {
      lastError = 'Formulario inválido';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    notifyListeners();
    try {
      final incident = Incident(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: (desc.isEmpty ? 'Reporte' : desc.split('\n').first.trim()),
        description: desc,
        photoPath: img ?? '',
        category: _mapStringToCategory(selectedCategory),
        status: IncidentStatus.pendiente,
        createdAt: DateTime.now(),
      );

      await _repository.createIncident(incident);
      return true;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ---- Utilidades ----
  IncidentCategory _mapStringToCategory(String? value) {
    switch (value) {
      case 'infraestructura':
        return IncidentCategory.infraestructura;
      case 'limpieza':
        return IncidentCategory.limpieza;
      case 'mobiliario':
      default:
        return IncidentCategory.mobiliario;
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
