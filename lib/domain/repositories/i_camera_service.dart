import 'dart:io';

// Contrato para cualquier servicio que necesite usar la cámara del dispositivo.
abstract class ICameraService {
  // Abre la cámara, toma una foto y devuelve el archivo resultante.
  //
  // Si el usuario cancela la acción, el método debe devolver null.
  Future<File?> takePicture();
}
