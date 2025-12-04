import '../enums/incident_category.dart';
import '../enums/incident_status.dart';

class Incident {
  final String id;
  final String title;
  final String description;
  final String photoPath;
  final IncidentCategory category;
  final IncidentStatus status;
  final DateTime createdAt;

  // 1. NUEVO CAMPO: Aquí guardaremos el UID de Firebase Auth (ej. "abc123XYZ")
  final String userId;

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.photoPath,
    required this.category,
    required this.status,
    required this.createdAt,
    // 2. REQUERIDO EN EL CONSTRUCTOR: No puede existir un incidente sin dueño
    required this.userId,
  });

  // 3. ACTUALIZAR COPYWITH: Para poder editar incidentes manteniendo el mismo dueño
  Incident copyWith({
    String? id,
    String? title,
    String? description,
    String? photoPath,
    IncidentCategory? category,
    IncidentStatus? status,
    DateTime? createdAt,
    String? userId, // <--- Nuevo parámetro opcional
  }) {
    return Incident(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      photoPath: photoPath ?? this.photoPath,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId, // <--- Si no cambia, mantén el actual
    );
  }

  // 4. ACTUALIZAR TOMAP: Para que al guardar en Firebase, se guarde el campo 'userId'
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'photoPath': photoPath,
      'category': category.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId, // <--- ¡Importante!
    };
  }

  // 5. ACTUALIZAR FROMMAP: Para leer el 'userId' cuando bajamos datos de Firebase
  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      photoPath: map['photoPath'] ?? '',
      category: IncidentCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => IncidentCategory.otro,
      ),
      status: IncidentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => IncidentStatus.pendiente,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      // <--- Leemos el ID. Si es antiguo y no tiene, ponemos cadena vacía para no romper la app.
      userId: map['userId'] ?? '',
    );
  }
}
