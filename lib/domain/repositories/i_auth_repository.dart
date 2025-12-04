import '../enums/user_role.dart';

abstract class IAuthRepository {
  // Iniciar sesión
  Future<void> signIn(String email, String password);

  // Registrar nuevo usuario
  Future<void> signUp(String email, String password);

  // Cerrar sesión
  Future<void> signOut();

  // Obtener el ID del usuario actual (útil para guardar reportes con el ID del creador)
  String? get currentUserId;

  // Nuevo método para saber si es admin o alumno
  Future<UserRole> getUserRole();
}
