import 'package:ngoni_pay/features/invoice/model/invoice_payment_model.dart';

class InvoiceModel {
  final int id;
  final String invoiceNumber;
  final double totalAmount;
  final String? pdfPath;
  final String sentVia;
  final DateTime createdAt;
  final InvoicePaymentModel payment;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.totalAmount,
    this.pdfPath,
    required this.sentVia,
    required this.createdAt,
    required this.payment,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      totalAmount: double.parse(json['total_amount'].toString()),
      pdfPath: json['pdf_path'],
      sentVia: json['sent_via'],
      createdAt: DateTime.parse(json['created_at']),
      payment: InvoicePaymentModel.fromJson(json['payment']),
    );
  }
}
