import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../favorites/data/models/favorite_city_model.dart';
import '../../../../core/config/app_config.dart';

class FavoritesProvider with ChangeNotifier {
  final Box _favoritesBox = Hive.box('favorites');
  List<FavoriteCity> _favorites = [];

  List<FavoriteCity> get favorites => _favorites;
  int get favoritesCount => _favorites.length;
  bool get isFull => _favorites.length >= AppConfig.maxFavoriteCities;

  FavoritesProvider() {
    _loadFavorites();
  }

  void _loadFavorites() {
    final List<dynamic> stored = _favoritesBox.get('cities', defaultValue: []);
    _favorites = stored
        .map((item) => FavoriteCity.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    notifyListeners();
  }

  // Add a city to favorites
  Future<bool> addFavorite(FavoriteCity city) async {
    if (_favorites.length >= AppConfig.maxFavoriteCities) {
      return false;
    }

    // Check if city already exists
    if (isFavorite(city.name, city.country)) {
      return false;
    }

    _favorites.add(city);
    await _saveFavorites();
    notifyListeners();
    return true;
  }

  // Remove a city from favorites
  Future<void> removeFavorite(String cityName, String country) async {
    _favorites.removeWhere(
      (city) => city.name == cityName && city.country == country,
    );
    await _saveFavorites();
    notifyListeners();
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(FavoriteCity city) async {
    if (isFavorite(city.name, city.country)) {
      await removeFavorite(city.name, city.country);
      return false;
    } else {
      return await addFavorite(city);
    }
  }

  // Check if a city is in favorites
  bool isFavorite(String cityName, String country) {
    return _favorites.any(
      (city) => city.name == cityName && city.country == country,
    );
  }

  // Clear all favorites
  Future<void> clearAll() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }

  // Save favorites to local storage
  Future<void> _saveFavorites() async {
    final data = _favorites.map((city) => city.toJson()).toList();
    await _favoritesBox.put('cities', data);
  }

  // Get favorite by index
  FavoriteCity? getFavoriteAt(int index) {
    if (index >= 0 && index < _favorites.length) {
      return _favorites[index];
    }
    return null;
  }

  // Sort favorites by name
  void sortByName() {
    _favorites.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  // Sort favorites by date added
  void sortByDate() {
    _favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    notifyListeners();
  }
}
