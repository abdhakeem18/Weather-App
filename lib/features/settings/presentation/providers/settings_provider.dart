import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider with ChangeNotifier {
  final Box _settingsBox = Hive.box('settings');

  bool _isDarkMode = false;
  String _temperatureUnit = 'celsius';
  String _windSpeedUnit = 'kmh';
  bool _locationEnabled = true;

  bool get isDarkMode => _isDarkMode;
  String get temperatureUnit => _temperatureUnit;
  String get windSpeedUnit => _windSpeedUnit;
  bool get locationEnabled => _locationEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    _isDarkMode = _settingsBox.get('darkMode', defaultValue: false);
    _temperatureUnit =
        _settingsBox.get('temperatureUnit', defaultValue: 'celsius');
    _windSpeedUnit = _settingsBox.get('windSpeedUnit', defaultValue: 'kmh');
    _locationEnabled = _settingsBox.get('location', defaultValue: true);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _settingsBox.put('darkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setTemperatureUnit(String unit) async {
    _temperatureUnit = unit;
    await _settingsBox.put('temperatureUnit', unit);
    notifyListeners();
  }

  Future<void> setWindSpeedUnit(String unit) async {
    _windSpeedUnit = unit;
    await _settingsBox.put('windSpeedUnit', unit);
    notifyListeners();
  }

  Future<void> toggleLocation() async {
    _locationEnabled = !_locationEnabled;
    await _settingsBox.put('location', _locationEnabled);
    notifyListeners();
  }

  // Convert temperature based on unit
  String formatTemperature(double celsius) {
    if (_temperatureUnit == 'fahrenheit') {
      final fahrenheit = (celsius * 9 / 5) + 32;
      return '${fahrenheit.round()}°F';
    }
    return '${celsius.round()}°C';
  }

  // Convert wind speed based on unit
  String formatWindSpeed(double mps) {
    if (_windSpeedUnit == 'mph') {
      final mph = mps * 2.237;
      return '${mph.toStringAsFixed(1)} mph';
    }
    final kmh = mps * 3.6;
    return '${kmh.toStringAsFixed(1)} km/h';
  }

  // Reset all settings
  Future<void> resetSettings() async {
    _isDarkMode = false;
    _temperatureUnit = 'celsius';
    _windSpeedUnit = 'kmh';
    _locationEnabled = true;

    await _settingsBox.clear();
    _loadSettings();
  }
}
