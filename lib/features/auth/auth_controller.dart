import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  Future<bool> login(String phone, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await AuthService.login(phone: phone, password: password);

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

   // REGISTER
  Future<bool> register({
    required String name,
    required String phone,
    required String password,
    String? email,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await AuthService.register(
        name: name,
        phone: phone,
        password: password,
        email: email,
      );
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
