class VehicleModel {
  final String? id;  // Made nullable
  final String? userId; // Driver ID, made nullable
  final String? vehicleNumber; // Nullable
  final String? vehicleType; // e.g., 'lorry', 'mini-truck', 'trailer', made nullable
  final String? model; // Nullable
  final String? brand; // Nullable
  final String? fuelType; // Added fuelType, nullable
  final int? year; // Nullable
  final String? rcBookUrl; // Document URL, made nullable
  final String? insuranceUrl; // Document URL, made nullable
  final DateTime? insuranceExpiry; // Nullable
  final String? status; // 'active', 'inactive', 'in_maintenance', made nullable
  final DateTime? createdAt; // Nullable
  final DateTime? updatedAt; // Nullable
  final DateTime? manufactureDate; // Added manufactureDate, nullable

  // Constructor with named parameters, all nullable
  VehicleModel({
    this.id,
    this.userId,
    this.vehicleNumber,
    this.vehicleType,
    this.model,
    this.brand,
    this.fuelType, // Added fuelType to the constructor
    this.year,
    this.rcBookUrl,
    this.insuranceUrl,
    this.insuranceExpiry,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.manufactureDate, // Added manufactureDate
  });

  // Factory constructor to create a VehicleModel from a Map
  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id']?.toString(),
      userId: map['userId']?.toString(),
      vehicleNumber: map['vehicleNumber']?.toString(),
      vehicleType: map['vehicleType']?.toString(),
      model: map['model']?.toString(),
      brand: map['brand']?.toString(),
      fuelType: map['fuelType']?.toString(), // Extract fuelType from map
      year: map['year'] != null ? int.tryParse(map['year'].toString()) : null,
      rcBookUrl: map['rcBookUrl']?.toString(),
      insuranceUrl: map['insuranceUrl']?.toString(),
      insuranceExpiry: map['insuranceExpiry'] != null
          ? DateTime.tryParse(map['insuranceExpiry'].toString())
          : null,
      status: map['status']?.toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      manufactureDate: map['manufactureDate'] != null
          ? DateTime.tryParse(map['manufactureDate'].toString())
          : null, // Extract manufactureDate from map
    );
  }

  // Method to convert a VehicleModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'userId': userId,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'model': model,
      'brand': brand,
      'fuelType': fuelType, // Add fuelType to map
      'year': year,
      'rcBookUrl': rcBookUrl,
      'insuranceUrl': insuranceUrl,
      'insuranceExpiry': insuranceExpiry?.toIso8601String(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'manufactureDate': manufactureDate?.toIso8601String(), // Add manufactureDate to map
    };
  }

  // Method to create a copy of the current instance with updated fields
  VehicleModel copyWith({
    String? id,
    String? userId,
    String? vehicleNumber,
    String? vehicleType,
    String? model,
    String? brand,
    String? fuelType, // Added fuelType to copyWith
    int? year,
    String? rcBookUrl,
    String? insuranceUrl,
    DateTime? insuranceExpiry,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? manufactureDate, // Added manufactureDate to copyWith
  }) {
    return VehicleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      model: model ?? this.model,
      brand: brand ?? this.brand,
      fuelType: fuelType ?? this.fuelType, // Set fuelType in copyWith
      year: year ?? this.year,
      rcBookUrl: rcBookUrl ?? this.rcBookUrl,
      insuranceUrl: insuranceUrl ?? this.insuranceUrl,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      manufactureDate: manufactureDate ?? this.manufactureDate, // Set manufactureDate in copyWith
    );
  }
}
