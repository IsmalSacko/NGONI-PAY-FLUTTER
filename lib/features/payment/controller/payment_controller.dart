import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/businesses/models/business_model.dart';
import 'package:ngoni_pay/features/businesses/services/business_service.dart';
import 'package:ngoni_pay/features/client/client_service.dart';
import 'package:ngoni_pay/features/payment/service/payment_service.dart';
import '../models/payment_create_model.dart';

class PaymentCreationResult {
  final bool success;
  final String? paymentUrl;
  final String? errorMessage;

  const PaymentCreationResult._({
    required this.success,
    this.paymentUrl,
    this.errorMessage,
  });

  factory PaymentCreationResult.success(String? paymentUrl) {
    return PaymentCreationResult._(success: true, paymentUrl: paymentUrl);
  }

  factory PaymentCreationResult.failure(String message) {
    return PaymentCreationResult._(success: false, errorMessage: message);
  }
}

class PaymentController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  BusinessModel? business;

  bool clientFound = false;

  Future<String?> findClientName({
    required int businessId,
    required String phone,
  }) async {
    try {
      final client = await ClientService.findClientByPhone(
        businessId: businessId,
        phone: phone,
      );

      if (client != null) {
        clientFound = true;
        notifyListeners();
        return client['name'];
      }

      clientFound = false;
      notifyListeners();
      return null;
    } catch (_) {
      clientFound = false;
      return null;
    }
  }

  Future<PaymentCreationResult> createPayment({
    required int businessId,
    required PaymentCreateModel payload,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final paymentUrl = await PaymentService.createPayment(
        businessId: businessId,
        payload: payload,
      );

      isLoading = false;
      notifyListeners();
      return PaymentCreationResult.success(paymentUrl);
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return PaymentCreationResult.failure(error ?? 'Unknown error');
    }
  }

  Future<void> loadBusiness(int businessId) async {
    business = await BusinessService.getBusiness(businessId);
    notifyListeners();
  }
}
