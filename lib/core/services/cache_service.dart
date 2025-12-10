import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/weather/data/models/weather_model.dart';
import '../../features/weather/data/models/forecast_model.dart';
import '../config/app_config.dart';

class CacheService {
  final Box _cacheBox = Hive.box('weather_cache');

  // Cache weather data
  Future<void> cacheWeather(Weather weather) async {
    final data = {
      'weather': weather.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _cacheBox.put('current_weather', json.encode(data));
  }

  // Get cached weather
  Weather? getCachedWeather() {
    final String? cached = _cacheBox.get('current_weather');
    if (cached == null) return null;

    try {
      final data = json.decode(cached);
      final timestamp = DateTime.parse(data['timestamp']);

      if (DateTime.now().difference(timestamp).inMinutes >
          AppConfig.cacheExpirationMinutes) {
        return null;
      }

      return Weather.fromJson(data['weather']);
    } catch (e) {
      return null;
    }
  }

  // Cache forecast data
  Future<void> cacheForecast(WeatherForecast forecast) async {
    final data = {
      'forecast': forecast.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _cacheBox.put('forecast', json.encode(data));
  }

  // Get cached forecast
  WeatherForecast? getCachedForecast() {
    final String? cached = _cacheBox.get('forecast');
    if (cached == null) return null;

    try {
      final data = json.decode(cached);
      final timestamp = DateTime.parse(data['timestamp']);

      if (DateTime.now().difference(timestamp).inMinutes >
          AppConfig.cacheExpirationMinutes) {
        return null;
      }

      return WeatherForecast.fromJson(data['forecast']);
    } catch (e) {
      return null;
    }
  }

  // Clear all cache
  Future<void> clearCache() async {
    await _cacheBox.clear();
  }

  // Check if cache is valid
  bool isCacheValid() {
    final String? cached = _cacheBox.get('current_weather');
    if (cached == null) return false;

    try {
      final data = json.decode(cached);
      final timestamp = DateTime.parse(data['timestamp']);
      return DateTime.now().difference(timestamp).inMinutes <=
          AppConfig.cacheExpirationMinutes;
    } catch (e) {
      return false;
    }
  }
}
