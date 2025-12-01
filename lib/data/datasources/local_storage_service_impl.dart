import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../domain/repositories/i_local_storage_service.dart';

class LocalStorageServiceImpl implements ILocalStorageService {
  LocalStorageServiceImpl({
    Future<Directory> Function()? getBaseDirectory,
  }) : _getBaseDirectory = getBaseDirectory ?? getApplicationDocumentsDirectory;

  // Permite cambiar el directorio base en pruebas si hace falta.
  final Future<Directory> Function() _getBaseDirectory;

  @override
  Future<File> saveImage(File tempImage) async {
    final baseDir = await _getBaseDirectory();

    final imagesDir = Directory('${baseDir.path}/incident_images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName = _buildFileName(tempImage);
    final targetPath = '${imagesDir.path}/$fileName';

    final persistedFile = await tempImage.copy(targetPath);
    return persistedFile;
  }

  String _buildFileName(File source) {
    // Usamos timestamp para evitar colisiones de nombres
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final originalPath = source.path;
    String extension = '.jpg';
    final dotIndex = originalPath.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < originalPath.length - 1) {
      extension = originalPath.substring(dotIndex);
    }

    return 'incident_$timestamp$extension';
  }
}
