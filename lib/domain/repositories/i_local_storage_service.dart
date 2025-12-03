import 'dart:io';

abstract class ILocalStorageService {
  // Recibe un archivo temporal y lo copia a una ubicación persistente de la app.
  // Devuelve el nuevo archivo con la ruta final.
  Future<File> saveImage(File tempImage);
}
