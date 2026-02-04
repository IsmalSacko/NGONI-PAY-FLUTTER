import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/subscription/model/subscription_create_result.dart';
import 'package:ngoni_pay/features/subscription/model/subscription_model.dart';

class SubscriptionService {
  static Future<SubscriptionCreateResult> createSubscription({
    required int businessId,
    required String plan,
    String? method,
  }) async {
    String? resolvedMethod = method;
    if (plan != 'free' && (resolvedMethod == null || resolvedMethod.isEmpty)) {
      resolvedMethod = 'orange_money';
    }
    final data = {
      "plan": plan,
      "starts_at": DateTime.now().toIso8601String(),
      if (plan != 'free')
        "method": (resolvedMethod != null && resolvedMethod.isNotEmpty)
            ? resolvedMethod
            : 'orange_money',
      if (plan != 'free')
        "payment_method": (resolvedMethod != null && resolvedMethod.isNotEmpty)
            ? resolvedMethod
            : 'orange_money',
    };

    final response = await ApiService.post(
      '/businesses/$businessId/subscription',
      auth: true,
      data: data,
    );

    final body = response.data;
    SubscriptionModel? subscription;
    String? checkoutUrl;
    int? paymentId;
    String? message;

    if (body is Map) {
      if (body['data'] is Map) {
        subscription = SubscriptionModel.fromJson(
          body['data'] as Map<String, dynamic>,
        );
      } else if (body['subscription'] is Map) {
        subscription = SubscriptionModel.fromJson(
          body['subscription'] as Map<String, dynamic>,
        );
      }

      final rawUrl = body['checkout_url'];
      if (rawUrl is String && rawUrl.trim().isNotEmpty) {
        checkoutUrl = rawUrl.trim();
      }

      final rawId = body['payment_id'];
      if (rawId is int) {
        paymentId = rawId;
      } else if (rawId is String) {
        paymentId = int.tryParse(rawId);
      }

      if (body['message'] is String) {
        message = body['message'] as String;
      }
    }

    return SubscriptionCreateResult(
      subscription: subscription,
      checkoutUrl: checkoutUrl,
      paymentId: paymentId,
      message: message,
    );
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
