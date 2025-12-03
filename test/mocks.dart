import 'package:fix_it_app/domain/models/incident.dart';
import 'package:fix_it_app/domain/repositories/i_incident_repository.dart';
import 'package:fix_it_app/domain/services/i_report_validator.dart';
import 'package:mocktail/mocktail.dart';

class MockIncidentRepository extends Mock implements IIncidentRepository {}

class MockReportValidator extends Mock implements IReportValidator {}

// Fallback si usamos any<Incident>().
class FakeIncident extends Fake implements Incident {}

void registerFixItFallbacks() {
  registerFallbackValue(FakeIncident());
}
