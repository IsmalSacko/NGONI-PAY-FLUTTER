import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/user/user_model.dart';

class ProfileService {
  // Profile service implementation
  static Future<UserModel> getMe() async {
    final response = await ApiService.get('/auth/me', auth: true);
    return UserModel.fromJson(response.data['data']);
  }

  // Update user profile
  static Future<void> updateProfile({
    required String name,
    required String phone,
    String? email,
  }) async {
    await ApiService.patch(
      '/auth/update-profile',
      auth: true,
      data: {
        'name': name,
        'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
      },
    );
  }
}
