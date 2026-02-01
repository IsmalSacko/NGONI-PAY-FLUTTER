import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/businesses/controllers/business_stats_controller.dart';
import 'package:ngoni_pay/features/businesses/services/stats_srvice.dart';
import 'package:ngoni_pay/features/dashboard/stats/daily/daily_stat.dart';

class StatsController extends ChangeNotifier {
  // 📊 Stats globales
  BusinessStats? stats;

  // 📈 Stats journalières (graphique)
  List<DailyStat> dailyStats = [];

  // 🔄 Loading séparés
  bool isLoadingStats = false;
  bool isLoadingDaily = false;

  String? error;

  // =====================
  // 🔹 STATS GLOBALES
  // =====================
  Future<void> loadStats(int businessId) async {
    try {
      isLoadingStats = true;
      notifyListeners();

      stats = await StatsService.getStats(businessId);
    } catch (e) {
      error = 'Impossible de charger les statistiques';
    } finally {
      isLoadingStats = false;
      notifyListeners();
    }
  }

  // =====================
  // 🔹 STATS JOURNALIÈRES
  // =====================
  Future<void> loadDailyStats({required int businessId, int days = 7}) async {
    try {
      isLoadingDaily = true;
      notifyListeners();

      dailyStats = await StatsService.getDailyStats(
        businessId: businessId,
        days: days,
      );
    } catch (e) {
      error = 'Impossible de charger le graphique';
    } finally {
      isLoadingDaily = false;
      notifyListeners();
    }
  }
}
