class InvoiceClientModel {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? address;

  InvoiceClientModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
  });

  factory InvoiceClientModel.fromJson(Map<String, dynamic> json) {
    return InvoiceClientModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }
}
