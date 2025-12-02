import 'package:fix_it_app/core/di/service_locator.dart';
import 'package:fix_it_app/domain/repositories/i_incident_repository.dart';
import 'package:fix_it_app/domain/services/i_report_validator.dart';
import 'package:fix_it_app/presentation/viewmodels/create_report_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MockIncidentRepository repo;
  late MockReportValidator validator;

  setUpAll(() {
    registerFixItFallbacks();
  });

  setUp(() {
    repo = MockIncidentRepository();
    validator = MockReportValidator();

    getIt.reset();
    getIt.registerLazySingleton<IIncidentRepository>(() => repo);
    getIt.registerLazySingleton<IReportValidator>(() => validator);
  });

  CreateReportViewModel buildVm() {
    return CreateReportViewModel();
  }

  group('CreateReportViewModel · submit()', () {
    test('NO guarda cuando validator indica inválido', () async {
      final vm = buildVm();

      when(
        () => validator.validate(
          description: any(named: 'description'),
          imagePath: any(named: 'imagePath'),
        ),
      ).thenReturn(const ValidationResult(isValid: false));

      final ok = await vm.submit();

      expect(ok, isFalse);
      verifyNever(() => repo.createIncident(any()));
    });

    test('Guarda 1 vez cuando validator indica válido', () async {
      final vm = buildVm();

      when(
        () => validator.validate(
          description: any(named: 'description'),
          imagePath: any(named: 'imagePath'),
        ),
      ).thenReturn(const ValidationResult(isValid: true));

      when(() => repo.createIncident(any())).thenAnswer((_) async {});

      final ok = await vm.submit();

      expect(ok, isTrue);
      verify(() => repo.createIncident(any())).called(1);
    });
  });
}
