import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/air_quality_model.dart';

class WeatherApiService {
  final String _baseUrl = AppConfig.baseUrl;
  final String _apiKey = AppConfig.apiKey;

  // Get current weather by city name
  Future<Weather> getCurrentWeatherByCity(String cityName) async {
    final url = Uri.parse(
      '$_baseUrl${AppConfig.currentWeatherEndpoint}?q=$cityName&appid=$_apiKey&units=${AppConfig.metric}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  // Get current weather by coordinates
  Future<Weather> getCurrentWeatherByCoordinates(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      '$_baseUrl${AppConfig.currentWeatherEndpoint}?lat=$latitude&lon=$longitude&appid=$_apiKey&units=${AppConfig.metric}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  // Get 5-day weather forecast
  Future<WeatherForecast> getForecast(double latitude, double longitude) async {
    final url = Uri.parse(
      '$_baseUrl${AppConfig.forecastEndpoint}?lat=$latitude&lon=$longitude&appid=$_apiKey&units=${AppConfig.metric}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load forecast data: ${response.statusCode}');
    }
  }

  // Get forecast by city name
  Future<WeatherForecast> getForecastByCity(String cityName) async {
    final url = Uri.parse(
      '$_baseUrl${AppConfig.forecastEndpoint}?q=$cityName&appid=$_apiKey&units=${AppConfig.metric}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load forecast data: ${response.statusCode}');
    }
  }

  // Get air quality data
  Future<AirQuality> getAirQuality(double latitude, double longitude) async {
    final url = Uri.parse(
      '$_baseUrl${AppConfig.airPollutionEndpoint}?lat=$latitude&lon=$longitude&appid=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AirQuality.fromJson(data['list'][0]);
    } else {
      throw Exception(
          'Failed to load air quality data: ${response.statusCode}');
    }
  }

  // Search cities by name
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    final url = Uri.parse(
      'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> results = json.decode(response.body);
      return results.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to search cities: ${response.statusCode}');
    }
  }

  // Get weather icon URL
  String getIconUrl(String iconCode) {
    return '${AppConfig.weatherIconUrl}/$iconCode@2x.png';
  }
}
