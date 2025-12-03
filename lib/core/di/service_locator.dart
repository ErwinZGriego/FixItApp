import 'package:fix_it_app/data/datasources/local_storage_service_impl.dart';
import 'package:fix_it_app/domain/repositories/i_local_storage_service.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/camera_service_impl.dart';
import '../../domain/repositories/i_camera_service.dart';

// Instancia global de GetIt (el Service Locator)
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Aquí registraremos nuestras dependencias más adelante.
  // El orden importa:
  // 1. External (Firebase, SharedPreferences, Dio)
  // 2. Data (Repositorios y Data Sources)
  // 3. Domain (Use Cases - opcional)
  // 4. Presentation (ViewModels/Blocs)

  // Servicio de cámara (infraestructura)
  getIt.registerLazySingleton<ICameraService>(() => CameraServiceImpl());

  getIt.registerLazySingleton<ILocalStorageService>(
    () => LocalStorageServiceImpl(),
  );
}
