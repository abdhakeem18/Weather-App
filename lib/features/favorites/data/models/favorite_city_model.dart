class FavoriteCity {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final DateTime addedAt;

  FavoriteCity({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.addedAt,
  });

  factory FavoriteCity.fromJson(Map<String, dynamic> json) {
    return FavoriteCity(
      name: json['name'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  String get displayName => '$name, $country';
}
