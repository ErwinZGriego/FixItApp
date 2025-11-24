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

  // Constructor Constante
  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.photoPath,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  // Método copyWith: Para crear copias modificadas (útil para actualizar estados)
  Incident copyWith({
    String? id,
    String? title,
    String? description,
    String? photoPath,
    IncidentCategory? category,
    IncidentStatus? status,
    DateTime? createdAt,
  }) {
    return Incident(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      photoPath: photoPath ?? this.photoPath,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convertir a Map (para guardar en Firebase/JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'photoPath': photoPath,
      // Guardamos el nombre del Enum como texto (ej. "mobiliario") para que sea legible en la BD
      'category': category.name,
      'status': status.name,
      // Guardamos la fecha en formato ISO8601 estándar
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Crear objeto desde Map (recuperar de Firebase/JSON)
  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      photoPath: map['photoPath'] ?? '',
      // Convertimos el String "mobiliario" de vuelta al Enum IncidentCategory.mobiliario
      // 'byName' es una función de Dart 2.15+ muy útil, pero agregamos un fallback por seguridad.
      category: IncidentCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => IncidentCategory.otro,
      ),
      status: IncidentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => IncidentStatus.pendiente,
      ),
      // Convertimos el String de fecha de vuelta a DateTime
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
