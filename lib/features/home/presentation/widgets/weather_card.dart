import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../weather/data/models/weather_model.dart';
import '../../../weather/data/services/weather_api_service.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../favorites/data/models/favorite_city_model.dart';
import '../../../../core/config/app_config.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final apiService = WeatherApiService();

    return Card(
      elevation: 6,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ],
          ),
        ),
        child: Column(
          children: [
            // City name and favorite button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${weather.cityName}, ${weather.country}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    favoritesProvider.isFavorite(
                            weather.cityName, weather.country)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () async {
                    final city = FavoriteCity(
                      name: weather.cityName,
                      country: weather.country,
                      latitude: weather.latitude,
                      longitude: weather.longitude,
                      addedAt: DateTime.now(),
                    );

                    final isCurrentlyFavorite = favoritesProvider.isFavorite(
                        weather.cityName, weather.country);

                    final success =
                        await favoritesProvider.toggleFavorite(city);

                    if (isCurrentlyFavorite) {
                      // Was removed from favorites
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${weather.cityName} removed from favorites'),
                          backgroundColor: Colors.orange,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else if (success) {
                      // Successfully added to favorites
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('${weather.cityName} added to favorites'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'VIEW',
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, '/favorites');
                            },
                          ),
                        ),
                      );
                    } else {
                      // Failed to add (limit reached or already exists)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            favoritesProvider.isFull
                                ? 'Maximum favorites limit reached (${favoritesProvider.favoritesCount}/${AppConfig.maxFavoriteCities})'
                                : '${weather.cityName} is already in favorites',
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Weather icon and temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: apiService.getIconUrl(weather.icon),
                  width: 120,
                  height: 120,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(width: 24),
                Text(
                  settingsProvider.formatTemperature(weather.temperature),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Weather description
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Feels like temperature
            Text(
              'Feels like ${settingsProvider.formatTemperature(weather.feelsLike)}',
              style: const TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
