class PaymentCreateModel {
  final String phone;
  final String? name;
  final double amount;
  final String currency;
  final String method;

  PaymentCreateModel({
    required this.phone,
    this.name,
    required this.amount,
    this.currency = 'XOF',
    required this.method,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      if (name != null && name!.isNotEmpty) 'name': name,
      'amount': amount,
      'currency': currency,
      'method': method,
    };
  }
}

