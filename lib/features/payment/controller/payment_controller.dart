import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/businesses/models/business_model.dart';
import 'package:ngoni_pay/features/businesses/services/business_service.dart';
import 'package:ngoni_pay/features/client/client_service.dart';
import 'package:ngoni_pay/features/payment/service/payment_service.dart';
import '../models/payment_create_result.dart';
import '../models/payment_create_model.dart';

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

  Future<PaymentCreateResult?> createPayment({
    required int businessId,
    required PaymentCreateModel payload,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final result = await PaymentService.createPayment(
        businessId: businessId,
        payload: payload,
      );

      isLoading = false;
      notifyListeners();
      return result;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = _extractErrorMessage(e.response?.data) ??
          e.message ??
          'Une erreur est survenue';
      error = status != null ? 'Erreur $status: $message' : message;
      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> loadBusiness(int businessId) async {
    business = await BusinessService.getBusiness(businessId);
    notifyListeners();
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }
    if (data is Map) {
      // Laravel style: { message: "...", errors: { field: ["..."] } }
      final errors = data['errors'];
      if (errors is Map) {
        for (final entry in errors.entries) {
          final value = entry.value;
          if (value is List && value.isNotEmpty) {
            final first = value.first;
            if (first is String && first.trim().isNotEmpty) {
              return first.trim();
            }
          } else if (value is String && value.trim().isNotEmpty) {
            return value.trim();
          }
        }
      }

      final candidates = [
        'message',
        'error',
        'errors',
        'detail',
        'title',
      ];
      for (final key in candidates) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return null;
  }
}
