import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/user/user_model.dart';

class ProfileService {
  // Profile service implementation
  static Future<UserModel> getMe() async {
    final response = await ApiService.get('/auth/me', auth: true);
    return UserModel.fromJson(response.data['data']);
  }
}