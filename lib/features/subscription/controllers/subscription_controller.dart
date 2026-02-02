import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/subscription/model/subscription_model.dart';
import 'package:ngoni_pay/features/subscription/service/subscription_service.dart';

class SubscriptionController extends ChangeNotifier {
  SubscriptionModel? subscription;
  bool isLoading = false;
  String? error;

  Future<bool> createSubscription({
    required int businessId,
    required String plan,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      subscription = await SubscriptionService.createSubscription(
        businessId: businessId,
        plan: plan,
      );

      return true;
    } catch (e) {
      error = "Erreur lors de la création de l’abonnement";
      return false;
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
}
