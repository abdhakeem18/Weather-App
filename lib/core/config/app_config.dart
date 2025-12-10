class AppConfig {
  static const String apiKey = 'f1dd82a83ced81c37f28c217c776a064';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String weatherIconUrl = 'https://openweathermap.org/img/wn';

  static const String currentWeatherEndpoint = '/weather';
  static const String forecastEndpoint = '/forecast';
  static const String oneCallEndpoint = '/onecall';
  static const String airPollutionEndpoint = '/air_pollution';

  static const int cacheExpirationMinutes = 10;
  static const int maxFavoriteCities = 10;
  static const double defaultLatitude = 8.032945;
  static const double defaultLongitude = 79.837684;

  static const String metric = 'metric';
  static const String imperial = 'imperial';

  static const double extremeTempHigh = 40.0;
  static const double extremeTempLow = 0.0;
  static const double strongWindSpeed = 50.0;
  static const int poorAirQualityIndex = 3;
}
