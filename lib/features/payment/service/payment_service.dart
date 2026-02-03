import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/payment/models/payment_create_result.dart';
import 'package:ngoni_pay/features/payment/models/payment_create_model.dart';
import 'package:ngoni_pay/features/payment/models/payment_list_item.dart';
import 'package:ngoni_pay/features/payment/models/payment_model.dart';

class PaymentService {
  // Créer un nouveau paiement pour une entreprise donnée
  static Future<PaymentCreateResult> createPayment({
    required int businessId,
    required PaymentCreateModel payload,
  }) async {
    final response = await ApiService.post(
      '/businesses/$businessId/payments',
      data: payload.toJson(),
      auth: true,
    );
    return PaymentCreateResult(
      checkoutUrl: _extractCheckoutUrl(response.data),
      paymentId: _extractPaymentId(response.data),
      status: _extractPaymentStatus(response.data),
    );
  }

  // Récupérer la liste des paiements pour une entreprise donnée
  static Future<List<PaymentListItem>> getPaymentsByBusiness({
    required int businessId,
    DateTime? date,
    String? status,
  }) async {
    final query = <String, dynamic>{};
    if (date != null) {
      query['date'] = date.toIso8601String().split('T').first;
    }
    final response = await ApiService.get(
      '/businesses/$businessId/payments',
      auth: true,
    );

    return (response.data['data'] as List)
        .map((e) => PaymentListItem.fromJson(e))
        .toList();
  }

  static Future<PaymentModel> getPaymentById({
    required int businessId,
    required int paymentId,
  }) async {
    final response = await ApiService.get(
      '/businesses/$businessId/payments/$paymentId',
      auth: true,
    );

    dynamic payload = response.data;
    if (payload is Map && payload['data'] != null) {
      payload = payload['data'];
    }
    if (payload is Map && payload['payment'] != null) {
      payload = payload['payment'];
    }

    return PaymentModel.fromJson(payload as Map<String, dynamic>);
  }

  static String? _extractCheckoutUrl(dynamic data) {
    const urlKeys = [
      'provider_checkout_url',
      'providerCheckoutUrl',
      'checkout_url',
      'checkoutUrl',
      'payment_url',
      'paymentUrl',
      'invoice_url',
      'invoiceUrl',
      'redirect_url',
      'redirectUrl',
      'url',
      'link',
    ];

    String? fromMap(Map<dynamic, dynamic> map) {
      for (final key in urlKeys) {
        final value = map[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }

      final nestedKeys = ['data', 'payment', 'invoice', 'payload'];
      for (final key in nestedKeys) {
        final value = map[key];
        if (value is Map) {
          final nested = fromMap(value);
          if (nested != null) return nested;
        }
      }

      return null;
    }

    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }
    if (data is Map) {
      return fromMap(data);
    }
    return null;
  }

  static int? _extractPaymentId(dynamic data) {
    int? fromMap(Map<dynamic, dynamic> map) {
      final paymentIdKeys = [
        'payment_id',
        'paymentId',
      ];
      for (final key in paymentIdKeys) {
        final value = map[key];
        if (value is int) return value;
        if (value is String) return int.tryParse(value);
      }

      if (map['payment'] is Map) {
        final value = (map['payment'] as Map)['id'];
        if (value is int) return value;
        if (value is String) return int.tryParse(value);
      }
      if (map['data'] is Map) {
        final value = (map['data'] as Map)['id'];
        if (value is int) return value;
        if (value is String) return int.tryParse(value);
      }
      if (map['id'] is int) return map['id'] as int;
      if (map['id'] is String) return int.tryParse(map['id'] as String);
      return null;
    }

    if (data is Map) {
      return fromMap(data);
    }
    return null;
  }

  static String? _extractPaymentStatus(dynamic data) {
    if (data is Map) {
      final direct = data['status'];
      if (direct is String && direct.trim().isNotEmpty) {
        return direct.trim();
      }
      if (data['data'] is Map) {
        final value = (data['data'] as Map)['status'];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
      if (data['payment'] is Map) {
        final value = (data['payment'] as Map)['status'];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return null;
  }
}
