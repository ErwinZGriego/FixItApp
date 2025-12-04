import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  // 1. Obtenemos la instancia (la puerta de entrada al servicio)
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Sube una imagen y devuelve la URL para descargarla.
  /// [imageFile]: El archivo físico en tu celular.
  /// [userId]: El ID del usuario (para crear carpetas organizadas).
  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      // 2. Definir el nombre del archivo
      // Usamos la fecha actual en milisegundos para asegurar que sea único
      // y no sobrescriba fotos anteriores.
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 3. Crear la Referencia (La Ruta)
      // Esto es como decir: "Ve a la carpeta 'incidents', luego a la carpeta del usuario,
      // y ahí crea un espacio para 'fileName'".
      final Reference ref = _storage.ref().child('incidents/$userId/$fileName');

      // 4. Subir el Archivo (UploadTask)
      // Esta línea inicia la subida real de los bytes.
      final UploadTask task = ref.putFile(imageFile);

      // Esperamos a que la subida termine (snapshot contiene el resultado)
      final TaskSnapshot snapshot = await task;

      // 5. Obtener la URL
      // Una vez subido, le pedimos a Firebase: "¿Cuál es el link público de esto?"
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Si algo falla (ej. no hay internet), lanzamos un error legible.
      throw Exception('Falló la subida de imagen: $e');
    }
  }
}
