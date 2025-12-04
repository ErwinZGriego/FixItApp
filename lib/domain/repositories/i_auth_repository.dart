abstract class IAuthRepository {
  // Iniciar sesión
  Future<void> signIn(String email, String password);

  // Registrar nuevo usuario
  Future<void> signUp(String email, String password);

  // Cerrar sesión
  Future<void> signOut();

  // Obtener el ID del usuario actual (útil para guardar reportes con el ID del creador)
  String? get currentUserId;
}
