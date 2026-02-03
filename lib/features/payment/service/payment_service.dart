import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/payment/models/payment_create_model.dart';
import 'package:ngoni_pay/features/payment/models/payment_list_item.dart';

class PaymentService {
  // Créer un nouveau paiement pour une entreprise donnée
  static Future<String?> createPayment({
    required int businessId,
    required PaymentCreateModel payload,
  }) async {
    final response = await ApiService.post(
      '/businesses/$businessId/payments',
      data: payload.toJson(),
      auth: true,
    );
    return _extractCheckoutUrl(response.data) ?? '';
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
}
