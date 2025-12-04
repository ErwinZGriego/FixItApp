import '../enums/user_role.dart';

class AppUser {
  final String id;
  final String email;
  final UserRole role;

  const AppUser({required this.id, required this.email, required this.role});

  // Para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role.name, // Guardamos "admin" o "student" como texto
    };
  }

  // Para leer de Firestore
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.student, // Por defecto, todos son alumnos
      ),
    );
  }
}
