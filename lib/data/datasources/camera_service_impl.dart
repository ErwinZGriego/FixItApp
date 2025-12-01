import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/i_camera_service.dart';

class CameraServiceImpl implements ICameraService {
  CameraServiceImpl({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<File?> takePicture() async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );

      if (xFile == null) {
        // Usuario canceló la foto
        return null;
      }

      return File(xFile.path);
    } catch (_) {
      // Aquí podríamos conectar un servicio de logging en el futuro.
      // Por ahora solo devolvemos null para indicar que falló.
      return null;
    }
  }
}
