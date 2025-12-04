import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/incident.dart';
import '../../domain/repositories/i_incident_repository.dart';

class FirebaseIncidentRepository implements IIncidentRepository {
  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Nombre de la colección en Firebase
  static const String _collection = 'incidents';

  @override
  Future<void> createIncident(Incident incident) async {
    // Usamos .set() para guardar el documento usando el ID que generamos en la app
    await _firestore
        .collection(_collection)
        .doc(incident.id)
        .set(incident.toMap());
  }

  @override
  Future<List<Incident>> getIncidents() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy(
          'createdAt',
          descending: true,
        ) // Ordenamos: más recientes primero
        .get();

    return snapshot.docs.map((doc) {
      // Convertimos el JSON de Firebase a nuestro objeto Incident
      final data = doc.data();
      // Aseguramos que el ID venga del documento (por seguridad)
      data['id'] = doc.id;
      return Incident.fromMap(data);
    }).toList();
  }

  @override
  Future<void> updateIncident(Incident incident) async {
    // Actualizamos solo los campos necesarios usando el mismo ID
    await _firestore
        .collection(_collection)
        .doc(incident.id)
        .update(incident.toMap());
  }
}
