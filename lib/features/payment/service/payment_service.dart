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
    return _extractPaymentUrl(response.data);
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

  static String? _extractPaymentUrl(dynamic data) {
    if (data is Map<String, dynamic>) {
      const candidates = [
        'payment_url',
        'checkout_url',
        'redirect_url',
        'pay_url',
        'url',
      ];

      for (final key in candidates) {
        final value = data[key];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }

      final nested = data['data'];
      if (nested != null && nested != data) {
        return _extractPaymentUrl(nested);
      }
    }

    return null;
  }
}
