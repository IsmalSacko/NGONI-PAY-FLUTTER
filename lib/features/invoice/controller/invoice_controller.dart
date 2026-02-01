import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/invoice/service/invoice_service.dart';
import '../model/invoice_model.dart';

class InvoiceController extends ChangeNotifier {
  InvoiceModel? invoice;
  bool isLoading = false;
  String? error;

  Future<void> loadInvoice(int paymentId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      invoice = await InvoiceService.getInvoiceByPayment(paymentId: paymentId);
    } catch (e) {
      error = 'Impossible de charger la facture';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
