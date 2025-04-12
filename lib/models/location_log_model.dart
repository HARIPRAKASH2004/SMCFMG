class LocationModel {
  final double? latitude;  // Nullable
  final double? longitude; // Nullable
  final String? address;   // Nullable
  final DateTime? lastUpdated; // Nullable

  LocationModel({
    this.latitude,
    this.longitude,
    this.address,
    this.lastUpdated,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
      address: map['address']?.toString(),
      lastUpdated: map['lastUpdated'] != null ? DateTime.tryParse(map['lastUpdated']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    DateTime? lastUpdated,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
