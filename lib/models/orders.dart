class OrderModel {
  final String orderId;
  final String driverId;
  final String driverName;
  final String pickupLocation;
  final String deliveryLocation;
  final String status; // e.g., 'pending', 'assigned', 'delivered', 'cancelled'
  final DateTime pickupTime;
  final DateTime deliveryTime;
  final double distanceInKm;
  final double loadWeightInTons;
  final String goodsType;
  final double fare;
  final String customerContact;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.orderId,
    required this.driverId,
    required this.driverName,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.status,
    required this.pickupTime,
    required this.deliveryTime,
    required this.distanceInKm,
    required this.loadWeightInTons,
    required this.goodsType,
    required this.fare,
    required this.customerContact,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: (map['orderId'] ?? '').toString(),
      driverId: (map['driverId'] ?? '').toString(),
      driverName: (map['driverName'] ?? '').toString(),
      pickupLocation: (map['pickupLocation'] ?? '').toString(),
      deliveryLocation: (map['deliveryLocation'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      pickupTime: DateTime.tryParse(map['pickupTime'] ?? '') ?? DateTime.now(),
      deliveryTime: DateTime.tryParse(map['deliveryTime'] ?? '') ?? DateTime.now(),
      distanceInKm: (map['distanceInKm'] ?? 0).toDouble(),
      loadWeightInTons: (map['loadWeightInTons'] ?? 0).toDouble(),
      goodsType: (map['goodsType'] ?? '').toString(),
      fare: (map['fare'] ?? 0).toDouble(),
      customerContact: (map['customerContact'] ?? '').toString(),
      notes: map['notes']?.toString(),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'driverId': driverId,
      'driverName': driverName,
      'pickupLocation': pickupLocation,
      'deliveryLocation': deliveryLocation,
      'status': status,
      'pickupTime': pickupTime.toIso8601String(),
      'deliveryTime': deliveryTime.toIso8601String(),
      'distanceInKm': distanceInKm,
      'loadWeightInTons': loadWeightInTons,
      'goodsType': goodsType,
      'fare': fare,
      'customerContact': customerContact,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? orderId,
    String? driverId,
    String? driverName,
    String? pickupLocation,
    String? deliveryLocation,
    String? status,
    DateTime? pickupTime,
    DateTime? deliveryTime,
    double? distanceInKm,
    double? loadWeightInTons,
    String? goodsType,
    double? fare,
    String? customerContact,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      status: status ?? this.status,
      pickupTime: pickupTime ?? this.pickupTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      loadWeightInTons: loadWeightInTons ?? this.loadWeightInTons,
      goodsType: goodsType ?? this.goodsType,
      fare: fare ?? this.fare,
      customerContact: customerContact ?? this.customerContact,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
