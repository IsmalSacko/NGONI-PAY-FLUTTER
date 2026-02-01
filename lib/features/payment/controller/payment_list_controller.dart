import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/payment/service/payment_service.dart';
import '../models/payment_list_item.dart';

class PaymentListController extends ChangeNotifier {
  List<PaymentListItem> payments = [];
  bool isLoading = false;
  String? error;

  Future<void> loadPayments({
    required int businessId,
    DateTime? date,
    String? status,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      payments = await PaymentService.getPaymentsByBusiness(
        businessId: businessId,
        date: date,
        status: status,
      );
    } catch (e) {
      error = "Impossible de charger les paiements";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Total Amount Calculations
  double get totalAmount {
    return payments.fold(0, (sum, item) => sum + item.payment.amount);
  }

  // Total Amount when Success
  double get totalAmountSuccess {
    return payments
        .where((item) => item.payment.status == 'success')
        .fold(0, (sum, item) => sum + item.payment.amount);
  }

  // Total Amount when Failed
  double get totalAmountFailed {
    return payments
        .where((item) => item.payment.status == 'failed')
        .fold(0, (sum, item) => sum + item.payment.amount);
  }

  // Total Amount when Pending
  double get totalAmountPending {
    return payments
        .where((item) => item.payment.status == 'pending')
        .fold(0, (sum, item) => sum + item.payment.amount);
  }

  // Recent Payments
  List<PaymentListItem> get recentPayments {
    return payments.take(5).toList();
  }
}
