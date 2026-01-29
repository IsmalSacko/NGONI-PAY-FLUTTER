import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/secure_storage.dart';
/// Service pour gérer les appels API
class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );



// Requête POST
  static Future<Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    bool auth = false,
  }) async {
    if (auth) {
      final token = await SecureStorage.getToken();
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }

    return _dio.post(endpoint, data: data);
  }

  // Requête GET
  static Future<Response> get(String endpoint, {bool auth = false, Map<String, dynamic>? queryParameters}) async {
    if (auth) {
      final token = await SecureStorage.getToken();
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return _dio.get(endpoint, queryParameters: queryParameters);
  }
}
