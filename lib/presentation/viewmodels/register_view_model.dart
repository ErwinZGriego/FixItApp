import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../domain/repositories/i_auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final IAuthRepository _authRepo = getIt<IAuthRepository>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register() async {
    // 1. Validaciones básicas locales
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      errorMessage = 'Ingresa un correo válido.';
      notifyListeners();
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      errorMessage = 'La contraseña debe tener al menos 6 caracteres.';
      notifyListeners();
      return false;
    }

    // 2. Intentar registro en Firebase
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authRepo.signUp(email, password);
      isLoading = false;
      notifyListeners();
      return true; // Éxito
    } catch (e) {
      isLoading = false;
      // Quitamos el prefijo "Exception: " si existe para que se vea limpio
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
