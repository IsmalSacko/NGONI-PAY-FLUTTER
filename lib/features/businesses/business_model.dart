class BusinessOwner {
  final int id;
  final String name;
  final String phone;

  BusinessOwner({required this.id, required this.name, required this.phone});

  factory BusinessOwner.fromJson(Map<String, dynamic> json) {
    return BusinessOwner(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class BusinessModel {
  // 🔹 Champs communs
  final String name;
  final String type;
  final String? address;
  final String? phone;

  // 🔹 Champs READ (API)
  final int? id;
  final bool? isActive;
  final BusinessOwner? owner;
  final DateTime? createdAt;

  BusinessModel({
    // CREATE
    required this.name,
    required this.type,
    this.address,
    this.phone,

    // READ
    this.id,
    this.isActive,
    this.owner,
    this.createdAt,
  });

  /// 🔹 CREATE
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      if (address != null && address!.isNotEmpty) 'address': address,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
    };
  }

  /// 🔹 READ (index / show)
  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      address: json['address'],
      phone: json['phone'],
      isActive: json['is_active'],
      owner: json['owner'] != null
          ? BusinessOwner.fromJson(json['owner'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
