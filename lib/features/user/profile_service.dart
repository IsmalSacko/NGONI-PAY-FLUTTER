import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/user/user_model.dart';

class ProfileService {
  // Profile service implementation
  static Future<UserModel> getMe() async {
    final response = await ApiService.get('/auth/me', auth: true);
    return UserModel.fromJson(response.data['data']);
  }

  static Future<String> buildAvatarBase64(XFile avatar) async {
    final bytes = await avatar.readAsBytes();
    final name = avatar.name.toLowerCase();
    var ext = 'jpg';
    if (name.contains('.')) {
      ext = name.split('.').last;
    }
    final b64 = base64Encode(bytes);
    return 'data:image/$ext;base64,$b64';
  }

  // Update user profile
  static Future<void> updateProfile({
    required String name,
    required String phone,
    String? email,
    XFile? avatar,
    String? avatarUrl,
    String? avatarBase64,
    bool removeAvatar = false,
  }) async {
    if (avatar != null) {
      final formData = FormData.fromMap({
        'name': name,
        'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
        '_method': 'PATCH',
        'avatar': await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.name,
        ),
      });

      await ApiService.postFormData(
        '/auth/update-profile',
        auth: true,
        data: formData,
      );
      return;
    }

    await ApiService.patch(
      '/auth/update-profile',
      auth: true,
      data: {
        'name': name,
        'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
        if (avatarUrl != null && avatarUrl.isNotEmpty)
          'avatar_url': avatarUrl,
        if (avatarBase64 != null && avatarBase64.isNotEmpty)
          'avatar_base64': avatarBase64,
        if (removeAvatar) 'remove_avatar': true,
      },
    );
  }
}
