class VehicleModel {
  final String id;
  final String userId; // driver ID
  final String vehicleNumber;
  final String vehicleType; // e.g. 'lorry', 'mini-truck', 'trailer'
  final String model;
  final String brand;
  final int year;
  final String rcBookUrl; // document URL
  final String insuranceUrl; // document URL
  final DateTime insuranceExpiry;
  final String status; // 'active', 'inactive', 'in_maintenance'
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.model,
    required this.brand,
    required this.year,
    required this.rcBookUrl,
    required this.insuranceUrl,
    required this.insuranceExpiry,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: (map['id'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      vehicleNumber: (map['vehicleNumber'] ?? '').toString(),
      vehicleType: (map['vehicleType'] ?? '').toString(),
      model: (map['model'] ?? '').toString(),
      brand: (map['brand'] ?? '').toString(),
      year: int.tryParse(map['year']?.toString() ?? '') ?? 0,
      rcBookUrl: (map['rcBookUrl'] ?? '').toString(),
      insuranceUrl: (map['insuranceUrl'] ?? '').toString(),
      insuranceExpiry: DateTime.tryParse(map['insuranceExpiry'] ?? '') ?? DateTime.now(),
      status: (map['status'] ?? 'active').toString(),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'model': model,
      'brand': brand,
      'year': year,
      'rcBookUrl': rcBookUrl,
      'insuranceUrl': insuranceUrl,
      'insuranceExpiry': insuranceExpiry.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  VehicleModel copyWith({
    String? id,
    String? userId,
    String? vehicleNumber,
    String? vehicleType,
    String? model,
    String? brand,
    int? year,
    String? rcBookUrl,
    String? insuranceUrl,
    DateTime? insuranceExpiry,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      model: model ?? this.model,
      brand: brand ?? this.brand,
      year: year ?? this.year,
      rcBookUrl: rcBookUrl ?? this.rcBookUrl,
      insuranceUrl: insuranceUrl ?? this.insuranceUrl,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
