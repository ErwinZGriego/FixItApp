import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoading = false;

  void updateEmail(String value) {
    email = value.trim();
  }

  void updatePassword(String value) {
    password = value;
  }

  Future<bool> submit() async {
    // Por ahora el login es falso, solo sirve para la HU-04
    isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 700));

    isLoading = false;
    notifyListeners();

    // Más adelante aquí se llamará al repositorio de auth
    return email.isNotEmpty && password.isNotEmpty;
  }
}
