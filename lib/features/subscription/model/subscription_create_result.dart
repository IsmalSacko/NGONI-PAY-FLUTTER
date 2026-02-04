import 'package:ngoni_pay/features/subscription/model/subscription_model.dart';

class SubscriptionCreateResult {
  final SubscriptionModel? subscription;
  final String? checkoutUrl;
  final int? paymentId;
  final String? message;

  const SubscriptionCreateResult({
    this.subscription,
    this.checkoutUrl,
    this.paymentId,
    this.message,
  });
}
