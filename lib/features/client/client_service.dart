import 'package:ngoni_pay/core/services/api_service.dart';

// class ClientService {
//   static Future<Map<String, dynamic>?> findClientByPhone({
//     required int businessId,
//     required String phone,
//   }) async {
//     final response = await ApiService.get(
//       '/businesses/$businessId/clients?phone=$phone',
//       auth: true,
//     );

//     final data = response.data['data'];

//     if (data == null || data.isEmpty) return null;

//     // on suppose que l’API retourne une liste
//     return data.first;
//   }
// }

class ClientService {
  static Future<Map<String, dynamic>?> findClientByPhone({
    required int businessId,
    required String phone,
  }) async {
    final response = await ApiService.get(
      '/businesses/$businessId/clients/find',
      auth: true,
      queryParameters: {'phone': phone},
    );

    return response.data['data'];
  }
}


