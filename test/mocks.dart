import 'package:fix_it_app/data/services/firebase_storage_service.dart';
import 'package:fix_it_app/domain/models/incident.dart';
import 'package:fix_it_app/domain/repositories/i_auth_repository.dart';
import 'package:fix_it_app/domain/repositories/i_camera_service.dart';
import 'package:fix_it_app/domain/repositories/i_incident_repository.dart';
import 'package:fix_it_app/domain/services/i_report_validator.dart';
import 'package:mocktail/mocktail.dart';

// Repositorios y Servicios
class MockIncidentRepository extends Mock implements IIncidentRepository {}

class MockReportValidator extends Mock implements IReportValidator {}

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockCameraService extends Mock implements ICameraService {}

class MockStorageService extends Mock implements FirebaseStorageService {}

// Entidades falsas
class FakeIncident extends Fake implements Incident {}

void registerFixItFallbacks() {
  registerFallbackValue(FakeIncident());
}
