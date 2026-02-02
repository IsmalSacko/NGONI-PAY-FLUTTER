import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/businesses/controllers/business_stats_controller.dart';
import 'package:ngoni_pay/features/businesses/services/stats_srvice.dart';
import 'package:ngoni_pay/features/subscription/controllers/subscription_controller.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  final int businessId;

  bool isLoading = false;
  String? error;

  BusinessStats? stats;

  DashboardController(this.businessId);

  Future<void> loadDashboard(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      // 1️⃣ Charger abonnement
      final subscriptionController = context.read<SubscriptionController>();

      await subscriptionController.loadSubscription(businessId);

      final subscription = subscriptionController.subscription;

      // 2️⃣ Bloquer si pas d’abonnement
      if (subscription == null || !subscription.isActive) {
        Navigator.pushReplacementNamed(context, '/subscription/$businessId');
        return;
      }

      // 3️⃣ Charger stats
      stats = await StatsService.getStats(businessId);
    } catch (e) {
      error = "Erreur chargement dashboard";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
