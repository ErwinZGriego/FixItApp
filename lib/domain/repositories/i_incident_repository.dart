import '../models/incident.dart';

// Definimos el contrato que debe cumplir cualquier proveedor de datos (Firebase, API, SQLite, etc.)
abstract class IIncidentRepository {
  // Guardar un nuevo incidente
  Future<void> createIncident(Incident incident);

  // Obtener la lista de todos los incidentes
  Future<List<Incident>> getIncidents();

  // Actualizar un incidente existente (ej. cambiar estado a 'resuelto')
  Future<void> updateIncident(Incident incident);
}
