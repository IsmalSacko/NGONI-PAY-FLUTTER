class DailyStat {
  final String day;
  final double amount;

  DailyStat({required this.day, required this.amount});

  factory DailyStat.fromJson(Map<String, dynamic> json) {
    return DailyStat(
      day: json['day'],
      amount: double.parse(json['amount'].toString()),
    );
  }
}
