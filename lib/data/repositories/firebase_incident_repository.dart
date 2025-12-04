import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/incident.dart';
import '../../domain/repositories/i_incident_repository.dart';

class FirebaseIncidentRepository implements IIncidentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'incidents';

  @override
  Future<void> createIncident(Incident incident) async {
    await _firestore
        .collection(_collection)
        .doc(incident.id)
        .set(incident.toMap());
  }

  @override
  Future<List<Incident>> getIncidents({String? userId}) async {
    // 1. Iniciamos la consulta base ordenando por fecha
    Query query = _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true);

    // 2. Si nos pasaron un userId, filtramos los resultados
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    // 3. Ejecutamos la consulta
    final snapshot = await query.get();

    // 4. Mapeamos los resultados
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Incident.fromMap(data);
    }).toList();
  }

  @override
  Future<void> updateIncident(Incident incident) async {
    await _firestore
        .collection(_collection)
        .doc(incident.id)
        .update(incident.toMap());
  }
}
