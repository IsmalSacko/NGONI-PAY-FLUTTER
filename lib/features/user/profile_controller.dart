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

  Future<bool> updateProfile({
    required String name,
    required String phone,
    String? email,
  }) async {
    try {
      await ProfileService.updateProfile(
        name: name,
        phone: phone,
        email: email,
      );
      await loadProfile();
      return true;
    } catch (e) {
      error = 'Impossible de mettre à jour le profil: $e';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
