class Vendor {
  final String vendorId;
  final String name;
  final String phone;
  final String email;
  final String companyName;
  final String address;
  final String gstNumber;

  Vendor({
    required this.vendorId,
    required this.name,
    required this.phone,
    required this.email,
    required this.companyName,
    required this.address,
    required this.gstNumber,
  });

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      vendorId: (map['vendorId'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      companyName: (map['companyName'] ?? '').toString(),
      address: (map['address'] ?? '').toString(),
      gstNumber: (map['gstNumber'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'name': name,
      'phone': phone,
      'email': email,
      'companyName': companyName,
      'address': address,
      'gstNumber': gstNumber,
    };
  }
}


class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class OrderModel {
  final String orderId;
  final String driverId;
  final String driverName;
  final String pickupLocation;
  final String deliveryLocation;
  final String status;
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
  final Vendor vendor;
  final Location location;

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
    required this.vendor,
    required this.location,
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
      vendor: Vendor.fromMap(map['vendor'] ?? {}),
      location: Location.fromMap(map['location'] ?? {}),
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
      'vendor': vendor.toMap(),
      'location': location.toMap(),
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
    Vendor? vendor,
    Location? location,
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
      vendor: vendor ?? this.vendor,
      location: location ?? this.location,
    );
  }
}
