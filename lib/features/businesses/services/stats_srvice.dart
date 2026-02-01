import 'package:ngoni_pay/core/services/api_service.dart';
import 'package:ngoni_pay/features/businesses/controllers/business_stats_controller.dart';
import 'package:ngoni_pay/features/dashboard/stats/daily/daily_stat.dart';

class StatsService {
  static Future<BusinessStats> getStats(int businessId) async {
    final response = await ApiService.get(
      '/businesses/$businessId/stats',
      auth: true,
    );

    return BusinessStats.fromJson(response.data['data']);
  }

  // daily stats

  static Future<List<DailyStat>> getDailyStats({
    required int businessId,
    required int days,
  }) async {
    final response = await ApiService.get(
      '/businesses/$businessId/stats/daily?days=$days',
      auth: true,
    );

    return (response.data['data'] as List)
        .map((e) => DailyStat.fromJson(e))
        .toList();
  }
}
