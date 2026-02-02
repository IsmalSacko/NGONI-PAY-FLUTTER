class SubscriptionModel {
  final int id;
  final String plan;
  final DateTime startsAt;
  final DateTime? endsAt;
  final bool isActive;

  SubscriptionModel({
    required this.id,
    required this.plan,
    required this.startsAt,
    required this.endsAt,
    required this.isActive,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      plan: json['plan'],
      startsAt: DateTime.parse(json['starts_at']),
      endsAt: json['ends_at'] != null ? DateTime.parse(json['ends_at']) : null,
      isActive: json['is_active'],
    );
  }
}
