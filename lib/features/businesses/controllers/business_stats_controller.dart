class BusinessStats {
  final double totalSuccess;
  final double totalPending;
  final double totalFailed;

  final int countSuccess;
  final int countPending;
  final int countFailed;

  final double today;
  final double last7Days;
  final double last30Days;

  BusinessStats({
    required this.totalSuccess,
    required this.totalPending,
    required this.totalFailed,
    required this.countSuccess,
    required this.countPending,
    required this.countFailed,
    required this.today,
    required this.last7Days,
    required this.last30Days,
  });

  factory BusinessStats.fromJson(Map<String, dynamic> json) {
    return BusinessStats(
      totalSuccess: double.parse(json['total_success'].toString()),
      totalPending: double.parse(json['total_pending'].toString()),
      totalFailed: double.parse(json['total_failed'].toString()),
      countSuccess: json['count_success'],
      countPending: json['count_pending'],
      countFailed: json['count_failed'],
      today: double.parse(json['today'].toString()),
      last7Days: double.parse(json['last_7_days'].toString()),
      last30Days: double.parse(json['last_30_days'].toString()),
    );
  }
}
