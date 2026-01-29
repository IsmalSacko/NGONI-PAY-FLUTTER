import 'payment_model.dart';
import 'payment_client_model.dart';

class PaymentListItem {
  final PaymentModel payment;
  final PaymentClientModel client;

  PaymentListItem({required this.payment, required this.client});

  factory PaymentListItem.fromJson(Map<String, dynamic> json) {
    return PaymentListItem(
      payment: PaymentModel.fromJson(json),
      client: PaymentClientModel.fromJson(json['client']),
    );
  }
}
