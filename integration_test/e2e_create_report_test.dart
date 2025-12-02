import 'dart:convert';
import 'dart:io';

import 'package:fix_it_app/data/repositories/incident_repository_impl.dart';
import 'package:fix_it_app/domain/repositories/i_camera_service.dart';
import 'package:fix_it_app/domain/repositories/i_incident_repository.dart';
import 'package:fix_it_app/domain/services/i_report_validator.dart';
import 'package:fix_it_app/domain/services/report_validator.dart';
import 'package:fix_it_app/presentation/app/fixit_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class _FakeCameraService implements ICameraService {
  @override
  Future<File?> takePicture() async {
    final dir = await Directory.systemTemp.createTemp('fixit_e2e_');
    final file = File('${dir.path}/fake.png');

    // PNG 1x1 blanco.
    const b64 =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Yv4SgAAAABJRU5ErkJggg==';
    final bytes = base64Decode(b64);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

void main() {
  final sl = GetIt.instance;

  setUpAll(() async {
    await sl.reset();
    sl.registerLazySingleton<IIncidentRepository>(
      () => IncidentRepositoryImpl(),
    );
    sl.registerLazySingleton<IReportValidator>(() => ReportValidator());
    sl.registerLazySingleton<ICameraService>(() => _FakeCameraService());
  });

  testWidgets('E2E: login -> home -> crear -> adjuntar -> enviar', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItApp());
    await tester.pumpAndSettle();

    // LOGIN
    await tester.enterText(
      find.byKey(const Key('login.email')),
      'test@demo.com',
    );
    await tester.enterText(find.byKey(const Key('login.password')), '123456');
    await tester.tap(find.byKey(const Key('login.submit')));
    await tester.pumpAndSettle();

    // HOME -> NUEVO REPORTE
    await tester.tap(find.text('Nuevo reporte'));
    await tester.pumpAndSettle();

    // CREATE REPORT FORM
    await tester.enterText(
      find.byKey(const Key('create.description')),
      'Incidente de prueba desde E2E',
    );

    await tester.tap(find.byKey(const Key('create.category')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('mobiliario').last);
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const Key('create.attach')),
    ); // usa la cámara fake
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('create.submit')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Reporte guardado', findRichText: true),
      findsOneWidget,
    );
  });
}
