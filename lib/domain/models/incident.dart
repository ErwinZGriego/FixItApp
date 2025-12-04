import '../enums/incident_area.dart'; // <--- NUEVO IMPORT
import '../enums/incident_building.dart'; // <--- NUEVO IMPORT
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
  final String? staffNotes;

  // NUEVOS CAMPOS REQUERIDOS
  final IncidentBuilding building;
  final IncidentArea area;

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.photoPath,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.userId,
    required this.building, // <--- REQUERIDO
    required this.area, // <--- REQUERIDO
    this.staffNotes,
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
    String? staffNotes,
    IncidentBuilding? building, // <---
    IncidentArea? area, // <---
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
      staffNotes: staffNotes ?? this.staffNotes,
      building: building ?? this.building, // <---
      area: area ?? this.area, // <---
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
      'staffNotes': staffNotes,
      'building': building.name, // <--- Guardamos como texto
      'area': area.name, // <--- Guardamos como texto
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
      staffNotes: map['staffNotes'],

      // Leemos y convertimos de texto a Enum (con valores por defecto por seguridad)
      building: IncidentBuilding.values.firstWhere(
        (e) => e.name == map['building'],
        orElse: () => IncidentBuilding.otro,
      ),
      area: IncidentArea.values.firstWhere(
        (e) => e.name == map['area'],
        orElse: () => IncidentArea.otro,
      ),
    );
  }
}
