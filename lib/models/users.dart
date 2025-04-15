import 'package:track/models/vechile.dart';

class UserModel {
  final String id;
  final String name;
  final int age;
  final String email;
  final String phone;
  final String password;
  final String city;
  final String district;
  final String type; // 'driver' or 'admin'
  final String status; // 'active', 'inactive', 'blocked'
  final double latitude;
  final double longitude;
  final DateTime lastUpdated;
  final bool isOnline;
  final String availability; // 'available', 'on_trip', etc.
  final String currentOrderId;
  final int totalOrdersCompleted;
  final double rating;
  final String fcmToken;
  final String? profileImageUrl;
  final String aadhaarNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<VehicleModel>? vehicles;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.phone,
    required this.password,
    required this.city,
    required this.district,
    required this.type,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.lastUpdated,
    required this.isOnline,
    required this.availability,
    required this.currentOrderId,
    required this.totalOrdersCompleted,
    required this.rating,
    required this.fcmToken,
    this.profileImageUrl,
    required this.aadhaarNumber,
    required this.createdAt,
    required this.updatedAt,
    this.vehicles,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      age: map['age'] ?? 0,
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      password: (map['password'] ?? '').toString(),
      city: (map['city'] ?? '').toString(),
      district: (map['district'] ?? '').toString(),
      type: (map['type'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      lastUpdated: DateTime.tryParse(map['lastUpdated'] ?? '') ?? DateTime.now(),
      isOnline: map['isOnline'] ?? false,
      availability: (map['availability'] ?? '').toString(),
      currentOrderId: (map['currentOrderId'] ?? '').toString(),
      totalOrdersCompleted: map['totalOrdersCompleted'] ?? 0,
      rating: (map['rating'] ?? 0).toDouble(),
      fcmToken: (map['fcmToken'] ?? '').toString(),
      profileImageUrl: map['profileImageUrl']?.toString(),
      aadhaarNumber: (map['aadhaarNumber'] ?? '').toString(),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
      // Parse vehicles correctly here
      vehicles: map['vehicles'] != null
          ? List<VehicleModel>.from(
          (map['vehicles'] as List).map((v) => VehicleModel.fromMap(v)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'email': email,
      'phone': phone,
      'password': password,
      'city': city,
      'district': district,
      'type': type,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isOnline': isOnline,
      'availability': availability,
      'currentOrderId': currentOrderId,
      'totalOrdersCompleted': totalOrdersCompleted,
      'rating': rating,
      'fcmToken': fcmToken,
      'profileImageUrl': profileImageUrl,
      'aadhaarNumber': aadhaarNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      // Map vehicles correctly here
      'vehicles': vehicles?.map((v) => v.toMap()).toList(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    int? age,
    String? email,
    String? phone,
    String? password,
    String? city,
    String? district,
    String? type,
    String? status,
    double? latitude,
    double? longitude,
    DateTime? lastUpdated,
    bool? isOnline,
    String? availability,
    String? currentOrderId,
    int? totalOrdersCompleted,
    double? rating,
    String? fcmToken,
    String? profileImageUrl,
    String? aadhaarNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<VehicleModel>? vehicles,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      city: city ?? this.city,
      district: district ?? this.district,
      type: type ?? this.type,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isOnline: isOnline ?? this.isOnline,
      availability: availability ?? this.availability,
      currentOrderId: currentOrderId ?? this.currentOrderId,
      totalOrdersCompleted: totalOrdersCompleted ?? this.totalOrdersCompleted,
      rating: rating ?? this.rating,
      fcmToken: fcmToken ?? this.fcmToken,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      vehicles: vehicles ?? this.vehicles,
    );
  }
}
