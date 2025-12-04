/*import 'dart:convert';
import 'dart:io';

import 'package:fix_it_app/data/services/firebase_storage_service.dart';
import 'package:fix_it_app/domain/models/incident.dart';
import 'package:fix_it_app/domain/repositories/i_auth_repository.dart';
import 'package:fix_it_app/domain/repositories/i_camera_service.dart';
import 'package:fix_it_app/domain/repositories/i_incident_repository.dart';
import 'package:fix_it_app/domain/services/i_report_validator.dart';
import 'package:fix_it_app/domain/services/report_validator.dart';
import 'package:fix_it_app/presentation/app/fixit_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// --- MOCKS Y FAKES LOCALES ---

class _FakeCameraService implements ICameraService {
  @override
  Future<File?> takePicture() async {
    final dir = await Directory.systemTemp.createTemp('fixit_e2e_');
    final file = File('${dir.path}/fake.png');
    // PNG 1x1 blanco base64
    const b64 =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Yv4SgAAAABJRU5ErkJggg==';
    final bytes = base64Decode(b64);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

class _FakeIncidentRepository implements IIncidentRepository {
  final List<Incident> _memoryDb = [];

  @override
  Future<void> createIncident(Incident incident) async {
    _memoryDb.add(incident);
  }

  @override
  Future<List<Incident>> getIncidents({String? userId}) async {
    if (userId != null) {
      return _memoryDb.where((i) => i.userId == userId).toList();
    }
    return _memoryDb;
  }

  @override
  Future<void> updateIncident(Incident incident) async {
    final index = _memoryDb.indexWhere((i) => i.id == incident.id);
    if (index != -1) {
      _memoryDb[index] = incident;
    }
  }
}

class _FakeAuthRepository implements IAuthRepository {
  @override
  String? get currentUserId => 'test_user_123';

  @override
  Future<void> signIn(String email, String password) async {
    // Simular delay de red y éxito siempre
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> signUp(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> signOut() async {}
}

class _FakeStorageService implements FirebaseStorageService {
  @override
  Future<String> uploadImage(File imageFile, String userId) async {
    return 'https://fake-url.com/photo.jpg';
  }
}

// --- TEST MAIN ---

void main() {
  final sl = GetIt.instance;

  setUpAll(() async {
    await sl.reset();

    // Registramos todas las dependencias FALSAS para que el test
    // no necesite Firebase real ni internet.
    sl.registerLazySingleton<IIncidentRepository>(
      () => _FakeIncidentRepository(),
    );
    sl.registerLazySingleton<IReportValidator>(() => ReportValidator());
    sl.registerLazySingleton<ICameraService>(() => _FakeCameraService());
    sl.registerLazySingleton<IAuthRepository>(() => _FakeAuthRepository());
    sl.registerLazySingleton<FirebaseStorageService>(
      () => _FakeStorageService(),
    );
  });

  testWidgets('E2E: login -> home -> crear -> adjuntar -> enviar', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItApp());
    await tester.pumpAndSettle();

    // LOGIN
    // Buscamos por Key para ser precisos
    await tester.enterText(
      find.byKey(const Key('login.email')),
      'test@demo.com',
    );
    await tester.enterText(find.byKey(const Key('login.password')), '123456');
    await tester.tap(find.byKey(const Key('login.submit')));

    // Esperamos a que la animación de navegación termine
    await tester.pumpAndSettle();

    // HOME -> NUEVO REPORTE
    // Verifica que estemos en Home buscando el texto de bienvenida o el botón
    expect(find.byKey(const Key('home.newReport')), findsOneWidget);

    await tester.tap(find.byKey(const Key('home.newReport')));
    await tester.pumpAndSettle();

    // CREATE REPORT FORM
    await tester.enterText(
      find.byKey(const Key('create.description')),
      'Incidente de prueba desde E2E',
    );

    // Seleccionar categoría
    await tester.tap(find.byKey(const Key('create.category')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text('Mobiliario').last,
    ); // Ojo con mayúsculas/minúsculas según tu lista
    await tester.pumpAndSettle();

    // Adjuntar foto (Usa el _FakeCameraService)
    await tester.tap(find.byKey(const Key('create.attach')));
    await tester.pumpAndSettle();

    // Enviar (Usa _FakeIncidentRepository y _FakeStorageService)
    await tester.tap(find.byKey(const Key('create.submit')));
    await tester.pumpAndSettle();

    // Verificamos éxito buscando el SnackBar o que se haya cerrado la pantalla
    // Como el éxito hace Navigator.pop, deberíamos volver al Home.
    expect(find.byKey(const Key('home.newReport')), findsOneWidget);

    // Opcional: Verificar mensaje de éxito si el SnackBar sigue visible
    expect(find.textContaining('Reporte guardado'), findsOneWidget);
  });
}
*/
