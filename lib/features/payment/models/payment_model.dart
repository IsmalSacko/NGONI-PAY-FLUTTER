class PaymentModel {
  final int id;
  final double amount;
  final String currency;
  final String method;
  final String status;
  final String transactionRef;
  final DateTime? paidAt;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    required this.transactionRef,
    this.paidAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      currency: json['currency'],
      method: json['method'],
      status: json['status'],
      transactionRef: json['transaction_ref'],
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
    );
  }
}

  