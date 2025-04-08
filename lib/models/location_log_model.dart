class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime lastUpdated;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.lastUpdated,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      address: (map['address'] ?? '').toString(),
      lastUpdated: DateTime.tryParse(map['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'lastUpdated': lastUpdated.toIso8601String(),
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
