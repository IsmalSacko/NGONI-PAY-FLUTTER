class PaymentCreateModel {
  final String phone;
  final String? name;
  final double amount;
  final String currency;
  final String method;
  final String? startsAt;

  PaymentCreateModel({
    required this.phone,
    this.name,
    required this.amount,
    this.currency = 'XOF',
    required this.method,
    this.startsAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      if (name != null && name!.isNotEmpty) 'name': name,
      'amount': amount,
      'currency': currency,
      'method': method,
      if (startsAt != null && startsAt!.isNotEmpty) 'starts_at': startsAt,
    };
  }
}

