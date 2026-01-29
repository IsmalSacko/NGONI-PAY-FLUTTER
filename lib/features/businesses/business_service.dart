import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/businesses/business_model.dart';

class BusinessService {
  // 🔹 CREATE
  static Future<void> createBusiness(BusinessModel business) async {
    await ApiService.post(
      '/businesses',
      auth: true,
     
        data : business.toJson(),
      
    );
  }

  // 🔹 LIST (index)
  static Future<List<BusinessModel>> getMyBusinesses({int page = 1}) async {
    final response = await ApiService.get('/businesses?page=$page', auth: true);

    return (response.data['data'] as List)
        .map((e) => BusinessModel.fromJson(e))
        .toList();
  }

  // 🔹 SHOW BUSINESS NAME BY ID
  static Future<BusinessModel> getBusiness(int id) async {
    final response = await ApiService.get('/businesses/$id', auth: true);

    return BusinessModel.fromJson(response.data['data']);
  }

}


