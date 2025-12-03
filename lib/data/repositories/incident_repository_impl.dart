// Implementación SQLite del repositorio de incidentes.
// Mantiene el contrato del dominio y mapea 1:1 con tu modelo Incident.

import 'package:sqflite/sqflite.dart';

import '../../domain/enums/incident_category.dart';
import '../../domain/enums/incident_status.dart';
import '../../domain/models/incident.dart';
import '../../domain/repositories/i_incident_repository.dart';
import '../datasources/db/app_database.dart';

class IncidentRepositoryImpl implements IIncidentRepository {
  static const _table = 'incidents';

  Future<Database> get _db async => AppDatabase.instance.database;

  Map<String, Object?> _toRow(Incident i) {
    // Guardamos enums como texto y fecha en ISO (coincide con tu fromMap/toMap).
    return {
      'id': i.id,
      'title': i.title,
      'description': i.description,
      'photo_path': i.photoPath,
      'category': i.category.name,
      'status': i.status.name,
      'created_at': i.createdAt.toIso8601String(),
    };
  }

  Incident _fromRow(Map<String, Object?> r) {
    // Reconstruimos usando las reglas del modelo (enums by name + ISO).
    return Incident(
      id: (r['id'] as String?) ?? '',
      title: (r['title'] as String?) ?? '',
      description: (r['description'] as String?) ?? '',
      photoPath: (r['photo_path'] as String?) ?? '',
      category: IncidentCategory.values.firstWhere(
        (e) => e.name == r['category'],
        orElse: () => IncidentCategory.otro,
      ), // :contentReference[oaicite:4]{index=4}
      status: IncidentStatus.values.firstWhere(
        (e) => e.name == r['status'],
        orElse: () => IncidentStatus.pendiente,
      ), // :contentReference[oaicite:5]{index=5}
      createdAt:
          DateTime.tryParse((r['created_at'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  @override
  Future<void> createIncident(Incident incident) async {
    final db = await _db;

    // id no es null en tu modelo; si viene vacío, generamos uno simple.
    final ensuredId = incident.id.trim().isEmpty
        ? DateTime.now().microsecondsSinceEpoch.toString()
        : incident.id;

    final toInsert = (ensuredId == incident.id)
        ? incident
        : incident.copyWith(id: ensuredId);

    await db.insert(
      _table,
      _toRow(toInsert),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Incident>> getIncidents() async {
    final db = await _db;
    final rows = await db.query(_table);
    final list = rows.map(_fromRow).toList();
    // Orden simple: recientes primero
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> updateIncident(Incident incident) async {
    final db = await _db;
    await db.update(
      _table,
      _toRow(incident),
      where: 'id = ?',
      whereArgs: [incident.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
