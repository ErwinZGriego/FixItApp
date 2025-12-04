import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../domain/enums/user_role.dart'; // <--- Importar Enum
import '../../domain/repositories/i_auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final IAuthRepository _authRepo = getIt<IAuthRepository>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  // Guardamos el rol aquí para que la UI lo pueda leer
  UserRole? _userRole;
  UserRole? get userRole => _userRole;

  Future<bool> submit() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1. Iniciar sesión en Auth (Email/Pass)
      await _authRepo.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // 2. Si pasó, ahora preguntamos a Firestore: ¿Qué rol tiene?
      _userRole = await _authRepo.getUserRole();

      isLoading = false;
      notifyListeners();
      return true; // Éxito total
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false; // Fallo
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
