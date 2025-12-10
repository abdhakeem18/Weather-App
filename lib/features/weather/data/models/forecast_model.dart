class ForecastDay {
  final DateTime date;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
  final String main;
  final int humidity;
  final double windSpeed;
  final int cloudiness;
  final double pop;

  ForecastDay({
    required this.date,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
    required this.main,
    required this.humidity,
    required this.windSpeed,
    required this.cloudiness,
    required this.pop,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      main: json['weather'][0]['main'] ?? '',
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      cloudiness: json['clouds']['all'] as int,
      pop: (json['pop'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': date.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
      },
      'weather': [
        {'description': description, 'icon': icon, 'main': main}
      ],
      'wind': {'speed': windSpeed},
      'clouds': {'all': cloudiness},
      'pop': pop,
    };
  }
}

class WeatherForecast {
  final String cityName;
  final String country;
  final List<ForecastDay> forecasts;

  WeatherForecast({
    required this.cityName,
    required this.country,
    required this.forecasts,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    List<ForecastDay> forecastList = [];

    if (json['list'] != null) {
      for (var item in json['list']) {
        forecastList.add(ForecastDay.fromJson(item));
      }
    }

    return WeatherForecast(
      cityName: json['city']['name'] ?? '',
      country: json['city']['country'] ?? '',
      forecasts: forecastList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': {
        'name': cityName,
        'country': country,
      },
      'list': forecasts.map((f) => f.toJson()).toList(),
    };
  }
}
