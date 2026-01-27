import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/core/storage/secure_storage.dart';

class AuthService {
 static Future<void> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('/auth/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await SecureStorage.saveToken(token);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
   await SecureStorage.clearToken();
  }

 
}




