import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  // Controllers para que la UI (y los tests) puedan leer/escribir directamente.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Estado simple que ya usabas.
  String email = '';
  String password = '';
  bool isLoading = false;

  LoginViewModel() {
    // Sincroniza los campos internos cuando cambian los controllers.
    emailController.addListener(() {
      email = emailController.text.trim();
    });
    passwordController.addListener(() {
      password = passwordController.text;
    });
  }

  // Alias para no romper la UI que usa `isBusy`.
  bool get isBusy => isLoading;

  // Métodos existentes siguen funcionando, ahora actualizan controllers.
  void updateEmail(String value) {
    emailController.text = value;
  }

  void updatePassword(String value) {
    passwordController.text = value;
  }

  Future<bool> submit() async {
    // Login simulado (HU-04)
    isLoading = true;
    notifyListeners();
    try {
      await Future<void>.delayed(const Duration(milliseconds: 2000));
      return email.isNotEmpty && password.isNotEmpty;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
