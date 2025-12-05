import 'package:fix_it_app/core/di/service_locator.dart';
import 'package:fix_it_app/data/services/firebase_storage_service.dart';
import 'package:fix_it_app/domain/repositories/i_auth_repository.dart';
import 'package:fix_it_app/domain/repositories/i_camera_service.dart';
import 'package:fix_it_app/domain/repositories/i_incident_repository.dart';
import 'package:fix_it_app/domain/services/i_report_validator.dart';
import 'package:fix_it_app/presentation/viewmodels/create_report_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MockIncidentRepository repo;
  late MockReportValidator validator;
  late MockAuthRepository authRepo;
  late MockStorageService storageService;
  late MockCameraService cameraService;

  setUpAll(() {
    registerFixItFallbacks();
  });

  setUp(() async {
    // <--- OJO: async aquí
    // 1. Instanciar mocks
    repo = MockIncidentRepository();
    validator = MockReportValidator();
    authRepo = MockAuthRepository();
    storageService = MockStorageService();
    cameraService = MockCameraService();

    // 2. Resetear GetIt esperando a que termine
    await getIt.reset();

    // 3. Registrar TODAS las dependencias
    getIt.registerLazySingleton<IIncidentRepository>(() => repo);
    getIt.registerLazySingleton<IReportValidator>(() => validator);
    getIt.registerLazySingleton<IAuthRepository>(() => authRepo);
    getIt.registerLazySingleton<FirebaseStorageService>(() => storageService);
    getIt.registerLazySingleton<ICameraService>(() => cameraService);

    // Stubs por defecto para evitar errores de null
    when(() => authRepo.currentUserId).thenReturn('test_user_id');
  });

  CreateReportViewModel buildVm() {
    return CreateReportViewModel();
  }

  group('CreateReportViewModel · submit()', () {
    test('NO guarda cuando los datos son inválidos (simulado)', () async {
      final vm = buildVm();

      // Simulamos que faltan datos (no seteamos nada)
      // Como no seteamos nada, canSubmit debería ser false internamente
      // y submit() debería retornar false.

      final ok = await vm.submit();

      expect(ok, isFalse);
      verifyNever(() => repo.createIncident(any()));
    });
  });
}
