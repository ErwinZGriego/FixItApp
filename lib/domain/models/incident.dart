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
  final String userId;
  final String? staffNotes; // <--- 1. NUEVO CAMPO

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.photoPath,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.userId,
    this.staffNotes, // <--- 2. Agregar al constructor (opcional)
  });

  Incident copyWith({
    String? id,
    String? title,
    String? description,
    String? photoPath,
    IncidentCategory? category,
    IncidentStatus? status,
    DateTime? createdAt,
    String? userId,
    String? staffNotes, // <--- 3. Agregar al copyWith
  }) {
    return Incident(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      photoPath: photoPath ?? this.photoPath,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      staffNotes: staffNotes ?? this.staffNotes, // <---
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'photoPath': photoPath,
      'category': category.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'staffNotes': staffNotes, // <--- 4. Guardar en mapa
    };
  }

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
      userId: map['userId'] ?? '',
      staffNotes: map['staffNotes'], // <--- 5. Leer del mapa
    );
  }
}
