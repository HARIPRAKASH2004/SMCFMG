class VehicleModel {
  final String? id;  // Made nullable
  final String? userId; // driver ID, made nullable
  final String? vehicleNumber; // Nullable
  final String? vehicleType; // e.g. 'lorry', 'mini-truck', 'trailer', made nullable
  final String? model; // Nullable
  final String? brand; // Nullable
  final int? year; // Nullable
  final String? rcBookUrl; // document URL, made nullable
  final String? insuranceUrl; // document URL, made nullable
  final DateTime? insuranceExpiry; // Nullable
  final String? status; // 'active', 'inactive', 'in_maintenance', made nullable
  final DateTime? createdAt; // Nullable
  final DateTime? updatedAt; // Nullable

  VehicleModel({
    this.id,
    this.userId,
    this.vehicleNumber,
    this.vehicleType,
    this.model,
    this.brand,
    this.year,
    this.rcBookUrl,
    this.insuranceUrl,
    this.insuranceExpiry,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id']?.toString(),
      userId: map['userId']?.toString(),
      vehicleNumber: map['vehicleNumber']?.toString(),
      vehicleType: map['vehicleType']?.toString(),
      model: map['model']?.toString(),
      brand: map['brand']?.toString(),
      year: map['year'] != null ? int.tryParse(map['year'].toString()) : null,
      rcBookUrl: map['rcBookUrl']?.toString(),
      insuranceUrl: map['insuranceUrl']?.toString(),
      insuranceExpiry: map['insuranceExpiry'] != null
          ? DateTime.tryParse(map['insuranceExpiry'])
          : null,
      status: map['status']?.toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
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
      'insuranceExpiry': insuranceExpiry?.toIso8601String(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
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
