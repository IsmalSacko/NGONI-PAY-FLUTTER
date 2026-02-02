import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/subscription/model/subscription_model.dart';

class SubscriptionService {
  static Future<SubscriptionModel> createSubscription({
    required int businessId,
    required String plan,
  }) async {
    final now = DateTime.now();
    final startsAt = now.toIso8601String();

    // Calculer ends_at selon le plan
    String? endsAt;
    if (plan == 'basic') {
      // Basic : 1 mois
      endsAt = now.add(const Duration(days: 30)).toIso8601String();
    } else if (plan == 'pro') {
      // Pro : 1 an
      endsAt = DateTime(now.year + 1, now.month, now.day).toIso8601String();
    }
    // free : pas de date de fin (endsAt reste null)

    final data = {
      "plan": plan,
      "starts_at": startsAt,
      if (endsAt != null) "ends_at": endsAt,
    };

    final response = await ApiService.post(
      '/businesses/$businessId/subscription',
      auth: true,
      data: data,
    );

    return SubscriptionModel.fromJson(response.data['data']);
  }

  static Future<SubscriptionModel?> getSubscription(int businessId) async {
    final response = await ApiService.get(
      '/businesses/$businessId/subscription',
      auth: true,
    );

    if (response.data['data'] == null) return null;

    return SubscriptionModel.fromJson(response.data['data']);
  }
}
