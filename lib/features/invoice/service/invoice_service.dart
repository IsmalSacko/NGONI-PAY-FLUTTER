import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/invoice/model/invoice_model.dart';

class InvoiceService {
  static Future<InvoiceModel> getInvoiceByPayment({
    required int paymentId,
  }) async {
    final response = await ApiService.get(
      '/payments/$paymentId/invoice',
      auth: true,
    );

    return InvoiceModel.fromJson(response.data['data']);
  }
}
