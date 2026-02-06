import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ngoni_pay/features/subscription/model/subscription_create_result.dart';
import 'package:ngoni_pay/features/subscription/model/subscription_model.dart';
import 'package:ngoni_pay/features/subscription/service/subscription_service.dart';

class SubscriptionController extends ChangeNotifier {
  SubscriptionModel? subscription;
  bool isLoading = false;
  String? error;

  Future<SubscriptionCreateResult?> createSubscription({
    required int businessId,
    required String plan,
    String? method,
  }) async {
    try {
      final resolvedMethod =
          plan == 'free' ? null : (method?.isNotEmpty == true ? method : 'orange_money');

      isLoading = true;
      error = null;
      notifyListeners();

      final result = await SubscriptionService.createSubscription(
        businessId: businessId,
        plan: plan,
        method: resolvedMethod,
      );

      subscription = result.subscription ?? subscription;
      return result;
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        error =
            "Accès refusé (403). Veuillez créer ou sélectionner une entreprise qui vous appartient.";
        return null;
      }
      error = _extractErrorMessage(e.response?.data) ??
          e.message ??
          "Erreur lors de la création de l’abonnement";
      return null;
    } catch (e) {
      error = "Erreur lors de la création de l’abonnement";
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSubscription(int businessId) async {
    try {
      isLoading = true;
      notifyListeners();

      subscription = await SubscriptionService.getSubscription(businessId);
    } catch (e) {
      error = "Erreur chargement abonnement";
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
}
