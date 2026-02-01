import 'invoice_client_model.dart';

class InvoicePaymentModel {
  final int id;
  final double amount;
  final String currency;
  final String method;
  final String status;
  final DateTime? paidAt;
  final InvoiceClientModel? client;

  InvoicePaymentModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    this.paidAt,
    this.client,
  });

  factory InvoicePaymentModel.fromJson(Map<String, dynamic> json) {
    return InvoicePaymentModel(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      currency: json['currency'],
      method: json['method'],
      status: json['status'],
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      client: json['client'] != null
          ? InvoiceClientModel.fromJson(json['client'])
          : null,
    );
  }
}
