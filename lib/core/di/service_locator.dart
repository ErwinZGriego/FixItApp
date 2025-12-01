import 'package:get_it/get_it.dart';

import '../../data/datasources/camera_service_impl.dart';
import '../../data/datasources/local_storage_service_impl.dart';
import '../../data/repositories/incident_repository_impl.dart';
import '../../domain/repositories/i_camera_service.dart';
import '../../domain/repositories/i_incident_repository.dart';
import '../../domain/repositories/i_local_storage_service.dart';
import '../../domain/services/i_report_validator.dart';
import '../../domain/services/report_validator.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Data sources
  getIt.registerLazySingleton<ICameraService>(() => CameraServiceImpl());
  getIt.registerLazySingleton<ILocalStorageService>(
    () => LocalStorageServiceImpl(),
  );

  // Dominio
  getIt.registerLazySingleton<IReportValidator>(() => ReportValidator());

  // Repositorio de incidentes (SQLite)
  getIt.registerLazySingleton<IIncidentRepository>(
    () => IncidentRepositoryImpl(),
  );
}
