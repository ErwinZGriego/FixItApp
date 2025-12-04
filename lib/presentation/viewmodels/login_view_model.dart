import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../domain/repositories/i_auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final IAuthRepository _authRepo =
      getIt<IAuthRepository>(); // Inyectamos el repo

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> submit() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authRepo.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      isLoading = false;
      notifyListeners();
      return true; // Éxito
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false; // Fallo
    }
  }
}
