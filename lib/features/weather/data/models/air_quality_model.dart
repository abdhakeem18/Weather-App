class AirQuality {
  final int aqi;
  final double co;
  final double no;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final double nh3;
  final DateTime dateTime;

  AirQuality({
    required this.aqi,
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.nh3,
    required this.dateTime,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final components = json['components'];
    return AirQuality(
      aqi: json['main']['aqi'] as int,
      co: (components['co'] as num).toDouble(),
      no: (components['no'] as num).toDouble(),
      no2: (components['no2'] as num).toDouble(),
      o3: (components['o3'] as num).toDouble(),
      so2: (components['so2'] as num).toDouble(),
      pm2_5: (components['pm2_5'] as num).toDouble(),
      pm10: (components['pm10'] as num).toDouble(),
      nh3: (components['nh3'] as num).toDouble(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }

  String get qualityDescription {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'main': {'aqi': aqi},
      'components': {
        'co': co,
        'no': no,
        'no2': no2,
        'o3': o3,
        'so2': so2,
        'pm2_5': pm2_5,
        'pm10': pm10,
        'nh3': nh3,
      },
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
