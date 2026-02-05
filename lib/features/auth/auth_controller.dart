import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'auth_service.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  Future<bool> login(String phone, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await AuthService.login(phone: phone, password: password);

      return true;
    } on DioException catch (e) {
      error = _buildDioErrorMessage(
            e,
            fallback: "Erreur lors de la connexion",
          ) ??
          "Erreur lors de la connexion";
      return false;
    } catch (e) {
      error = "Erreur lors de la connexion";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

   // REGISTER
  Future<bool> register({
    required String name,
    required String phone,
    required String password,
    String? email,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await AuthService.register(
        name: name,
        phone: phone,
        password: password,
        email: email,
      );
      return true;
    } on DioException catch (e) {
      error = _buildDioErrorMessage(
            e,
            fallback: "Erreur lors de l’inscription",
          ) ??
          "Erreur lors de l’inscription";
      return false;
    } catch (e) {
      error = "Erreur lors de l’inscription";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is String && data.trim().isNotEmpty) return data.trim();
    if (data is Map) {
      final errors = data['errors'];
      if (errors is Map) {
        for (final entry in errors.entries) {
          final value = entry.value;
          if (value is List && value.isNotEmpty) {
            final first = value.first;
            if (first is String && first.trim().isNotEmpty) {
              return first.trim();
            }
          } else if (value is String && value.trim().isNotEmpty) {
            return value.trim();
          }
        }
      }
      final candidates = ['message', 'error', 'detail', 'title'];
      for (final key in candidates) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return null;
  }

  String? _buildDioErrorMessage(
    DioException e, {
    required String fallback,
  }) {
    final extracted = _extractErrorMessage(e.response?.data);
    if (extracted != null) return extracted;

    final status = e.response?.statusCode;
    if (status != null) {
      if (status >= 500) {
        return "Erreur serveur ($status). Réessayez plus tard.";
      }
      if (status == 401) return "Identifiants invalides.";
      if (status == 422) return "Données invalides. Vérifiez vos champs.";
      if (status == 400) return "Requête invalide.";
    }

    final message = e.message;
    if (message != null && message.trim().isNotEmpty) {
      return message.trim();
    }

    return fallback;
  }
}
