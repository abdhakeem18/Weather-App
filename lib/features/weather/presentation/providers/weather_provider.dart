import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/weather_model.dart';
import '../../data/models/forecast_model.dart';
import '../../data/models/air_quality_model.dart';
import '../../data/services/weather_api_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/cache_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherApiService _apiService = WeatherApiService();
  final LocationService _locationService = LocationService();
  final CacheService _cacheService = CacheService();

  Weather? _currentWeather;
  WeatherForecast? _forecast;
  AirQuality? _airQuality;
  bool _isLoading = false;
  String? _errorMessage;
  Position? _currentPosition;

  Weather? get currentWeather => _currentWeather;
  WeatherForecast? get forecast => _forecast;
  AirQuality? get airQuality => _airQuality;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Position? get currentPosition => _currentPosition;

  // Get weather by current location
  Future<void> getWeatherByCurrentLocation() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Get current position
      _currentPosition = await _locationService.getCurrentLocation();

      // Fetch weather data
      await _fetchWeatherData(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _loadCachedData();
    } finally {
      _setLoading(false);
    }
  }

  // Get weather by city name
  Future<void> getWeatherByCity(String cityName) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _currentWeather = await _apiService.getCurrentWeatherByCity(cityName);

      // Cache the weather data
      await _cacheService.cacheWeather(_currentWeather!);

      // Fetch additional data
      await _fetchForecastAndAirQuality(
        _currentWeather!.latitude,
        _currentWeather!.longitude,
      );
    } catch (e) {
      _errorMessage = 'City not found or API error: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Get weather by coordinates
  Future<void> getWeatherByCoordinates(double lat, double lon) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _fetchWeatherData(lat, lon);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Fetch all weather data
  Future<void> _fetchWeatherData(double lat, double lon) async {
    _currentWeather =
        await _apiService.getCurrentWeatherByCoordinates(lat, lon);

    // Cache the weather data
    await _cacheService.cacheWeather(_currentWeather!);

    // Fetch forecast and air quality in parallel
    await _fetchForecastAndAirQuality(lat, lon);
  }

  // Fetch forecast and air quality data
  Future<void> _fetchForecastAndAirQuality(double lat, double lon) async {
    try {
      final results = await Future.wait([
        _apiService.getForecast(lat, lon),
        _apiService.getAirQuality(lat, lon),
      ]);

      _forecast = results[0] as WeatherForecast;
      _airQuality = results[1] as AirQuality;

      // Cache forecast
      await _cacheService.cacheForecast(_forecast!);
    } catch (e) {
      debugPrint('Error fetching forecast/air quality: $e');
    }
  }

  // Load cached data
  void _loadCachedData() {
    _currentWeather = _cacheService.getCachedWeather();
    _forecast = _cacheService.getCachedForecast();
    notifyListeners();
  }

  // Refresh weather data
  Future<void> refresh() async {
    if (_currentWeather != null) {
      await getWeatherByCoordinates(
        _currentWeather!.latitude,
        _currentWeather!.longitude,
      );
    } else {
      await getWeatherByCurrentLocation();
    }
  }

  // Check if weather alert should be shown
  bool hasWeatherAlert() {
    if (_currentWeather == null) return false;

    // Check extreme temperature
    if (_currentWeather!.temperature > 40 || _currentWeather!.temperature < 0) {
      return true;
    }

    // Check strong wind
    if (_currentWeather!.windSpeed > 50) {
      return true;
    }

    // Check poor air quality
    if (_airQuality != null && _airQuality!.aqi >= 4) {
      return true;
    }

    return false;
  }

  // Get alert message
  String? getAlertMessage() {
    if (!hasWeatherAlert()) return null;

    List<String> alerts = [];

    if (_currentWeather!.temperature > 40) {
      alerts.add('⚠️ Extreme heat warning');
    } else if (_currentWeather!.temperature < 0) {
      alerts.add('❄️ Freezing temperature warning');
    }

    if (_currentWeather!.windSpeed > 50) {
      alerts.add('💨 Strong wind warning');
    }

    if (_airQuality != null && _airQuality!.aqi >= 4) {
      alerts.add('🏭 Poor air quality alert');
    }

    return alerts.join('\n');
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
