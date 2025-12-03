import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../domain/repositories/i_camera_service.dart';
import '../../domain/repositories/i_local_storage_service.dart';

import '../../domain/services/i_report_validator.dart';

class CreateReportViewModel extends ChangeNotifier {
  CreateReportViewModel({
    ICameraService? cameraService,
    ILocalStorageService? localStorageService,
    IReportValidator? reportValidator,
  }) : _camera = cameraService ?? getIt<ICameraService>(),
       _storage = localStorageService ?? getIt<ILocalStorageService>(),
       _validator = reportValidator ?? getIt<IReportValidator>() {
    // Notificamos cambios cuando el usuario escribe.
    descriptionController.addListener(notifyListeners);
  }

  final ICameraService _camera;
  final ILocalStorageService _storage;
  final IReportValidator _validator;

  final TextEditingController descriptionController = TextEditingController();

  final List<String> categories = const [
    'Mantenimiento',
    'Seguridad',
    'Limpieza',
    'Infraestructura',
    'Otro',
  ];

  String? selectedCategory;
  String? imagePath; // ruta persistente
  bool isBusy = false;

  // Estado derivado: solo permitimos enviar si pasa validación.
  bool get canSubmit => _validator
      .validate(description: descriptionController.text, imagePath: imagePath)
      .isValid;

  Future<void> attachPhoto() async {
    if (isBusy) return;
    isBusy = true;
    notifyListeners();

    try {
      final tempFile = await _camera.takePicture();
      if (tempFile == null) return;

      final saved = await _storage.saveImage(tempFile);
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

  /// helper para el botón Enviar: valida y responde si está listo.
  Future<bool> trySubmit() async {
    final result = _validator.validate(
      description: descriptionController.text,
      imagePath: imagePath,
    );
    return result.isValid;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
