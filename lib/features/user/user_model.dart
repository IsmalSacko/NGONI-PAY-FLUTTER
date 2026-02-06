import 'package:ngoni_pay/core/config/api_config.dart';

class UserModel {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String role;
  final String? avatarUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      role: json['role'] ?? '',
      avatarUrl: _normalizeAvatarUrl(json['avatar_url']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static String? _normalizeAvatarUrl(dynamic value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;

    // Build absolute URL from Api base
    final base = Uri.parse(ApiConfig.baseUrl);
    final apiPath = base.path.replaceAll(RegExp(r'/+$'), '');
    final rootPath =
        apiPath.endsWith('/api') ? apiPath.substring(0, apiPath.length - 4) : apiPath;
    final root = base.replace(path: rootPath, query: null, fragment: null);

    if (raw.startsWith('/')) {
      return root.resolve(raw).toString();
    }

    return root.resolve('/$raw').toString();
  }
}
