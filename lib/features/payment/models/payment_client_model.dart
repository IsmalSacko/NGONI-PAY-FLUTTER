class PaymentClientModel {
  final int id;
  final String name;
  final String phone;

  PaymentClientModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory PaymentClientModel.fromJson(Map<String, dynamic> json) {
    return PaymentClientModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
