class PaymentModel {
  final String id;
  final String description;
  final double amount;
  final DateTime createdAt;
  final String status;

  PaymentModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}
