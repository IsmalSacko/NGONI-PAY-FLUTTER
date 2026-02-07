import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/secure_storage.dart';

/// Service pour gérer les appels API
class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  static Future<Options> _options({required bool auth}) async {
    if (!auth) {
      return Options(headers: {'Accept': 'application/json'});
    }
    final token = await SecureStorage.getToken();
    return Options(
      headers: {
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  // Requête POST
  static Future<Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    bool auth = false,
  }) async {
    final options = await _options(auth: auth);
    return _dio.post(endpoint, data: data, options: options);
  }

  // Requête GET
  static Future<Response> get(
    String endpoint, {
    bool auth = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    final options = await _options(auth: auth);
    return _dio.get(endpoint, queryParameters: queryParameters, options: options);
  }

  // Requête PATCH
  static Future<Response> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    bool auth = false,
  }) async {
    final options = await _options(auth: auth);
    return _dio.patch(endpoint, data: data, options: options);
  }

  // Requête PATCH multipart (FormData)
  static Future<Response> patchFormData(
    String endpoint, {
    required FormData data,
    bool auth = false,
  }) async {
    final options = await _options(auth: auth);
    return _dio.patch(endpoint, data: data, options: options);
  }

  // Requête POST multipart (FormData)
  static Future<Response> postFormData(
    String endpoint, {
    required FormData data,
    bool auth = false,
  }) async {
    final options = await _options(auth: auth);
    return _dio.post(endpoint, data: data, options: options);
  }

  // Requête DELETE
  static Future<Response> delete(String endpoint, {bool auth = false}) async {
    final options = await _options(auth: auth);
    return _dio.delete(endpoint, options: options);
  }
}
