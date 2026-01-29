import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/user/profile_service.dart';
import 'package:ngoni_pay/features/user/user_model.dart';

class ProfileController extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;
  String? error;

  Future<void> loadProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await ProfileService.getMe();
    } catch (e) {
      error = 'Impossible de charger le profil: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}