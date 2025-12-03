import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../domain/repositories/i_camera_service.dart';
import '../../domain/repositories/i_local_storage_service.dart';

class CreateReportViewModel extends ChangeNotifier {
  CreateReportViewModel({
    ICameraService? cameraService,
    ILocalStorageService? localStorageService,
  }) : _camera = cameraService ?? getIt<ICameraService>(),
       _storage = localStorageService ?? getIt<ILocalStorageService>();

  final ICameraService _camera;
  final ILocalStorageService _storage;

  // Texto libre del reporte
  final TextEditingController descriptionController = TextEditingController();

  // Lista categorias
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

  // Adjuntar foto desde la cámara y guardarla de forma persistente
  Future<void> attachPhoto() async {
    if (isBusy) return;
    isBusy = true;
    notifyListeners();

    try {
      final tempFile = await _camera.takePicture();
      if (tempFile == null) {
        // Usuario canceló
        return;
      }

      // Guardamos en almacenamiento persistente
      final saved = await _storage.saveImage(tempFile);
      imagePath = saved.path;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  // Cambiar categoría
  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
