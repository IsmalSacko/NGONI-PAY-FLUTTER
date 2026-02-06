import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/core/auth/auth_notifier.dart';
import 'package:ngoni_pay/core/storage/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> _resetBusinessCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_business_id');
  }

  static Future<void> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        '/auth/login',
        data: {'phone': phone, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token is! String || token.isEmpty) {
          throw Exception('Token manquant');
        }
        await SecureStorage.saveToken(token);
        await _resetBusinessCache();
        notifyAuthChanged();
      } else {
        throw Exception('Échec de la connexion');
      }
    } catch (e) {
      rethrow;
    }
  }

  // 🆕 REGISTER/ INSCRIPTION
  static Future<void> register({
    required String name,
    required String phone,
    required String password,
    String? email,
  }) async {
    try {
      final response = await ApiService.post(
        '/auth/register',
        data: {
          'name': name,
          'phone': phone,
          'password': password,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 🔐 auto-login après inscription
        final token = response.data['token'];
        if (token is! String || token.isEmpty) {
          throw Exception('Token manquant');
        }
        await SecureStorage.saveToken(token);
        await _resetBusinessCache();
        notifyAuthChanged();
      } else {
        throw Exception('Échec de l’inscription');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearToken();
    notifyAuthChanged();
  }
}
