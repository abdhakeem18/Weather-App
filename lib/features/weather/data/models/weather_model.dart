class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDegree;
  final int cloudiness;
  final String description;
  final String icon;
  final String main;
  final DateTime dateTime;
  final int sunrise;
  final int sunset;
  final double latitude;
  final double longitude;
  final int visibility;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDegree,
    required this.cloudiness,
    required this.description,
    required this.icon,
    required this.main,
    required this.dateTime,
    required this.sunrise,
    required this.sunset,
    required this.latitude,
    required this.longitude,
    required this.visibility,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      pressure: json['main']['pressure'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDegree: json['wind']['deg'] as int,
      cloudiness: json['clouds']['all'] as int,
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      main: json['weather'][0]['main'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      sunrise: json['sys']['sunrise'] as int,
      sunset: json['sys']['sunset'] as int,
      latitude: (json['coord']['lat'] as num).toDouble(),
      longitude: (json['coord']['lon'] as num).toDouble(),
      visibility: json['visibility'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {'country': country, 'sunrise': sunrise, 'sunset': sunset},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {'speed': windSpeed, 'deg': windDegree},
      'clouds': {'all': cloudiness},
      'weather': [
        {'description': description, 'icon': icon, 'main': main}
      ],
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'coord': {'lat': latitude, 'lon': longitude},
      'visibility': visibility,
    };
  }
}
