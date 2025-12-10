import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../weather/data/models/weather_model.dart';
import '../../../weather/data/services/weather_api_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Map<String, Weather?> _weatherCache = {};
  final WeatherApiService _apiService = WeatherApiService();

  Future<Weather?> _getWeatherForCity(String cityName, String country) async {
    final key = '$cityName,$country';

    if (_weatherCache.containsKey(key)) {
      return _weatherCache[key];
    }

    try {
      final weather = await _apiService.getCurrentWeatherByCity(cityName);
      setState(() {
        _weatherCache[key] = weather;
      });
      return weather;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, provider, child) {
              if (provider.favorites.isEmpty) return const SizedBox();

              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'sort_name') {
                    provider.sortByName();
                  } else if (value == 'sort_date') {
                    provider.sortByDate();
                  } else if (value == 'clear_all') {
                    _showClearDialog(context, provider);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'sort_name',
                    child: Text('Sort by Name'),
                  ),
                  const PopupMenuItem(
                    value: 'sort_date',
                    child: Text('Sort by Date'),
                  ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Text('Clear All'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          if (favoritesProvider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorite cities yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add cities from the home screen',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoritesProvider.favorites.length,
            itemBuilder: (context, index) {
              final city = favoritesProvider.favorites[index];

              return FutureBuilder<Weather?>(
                future: _getWeatherForCity(city.name, city.country),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingCard();
                  }

                  final weather = snapshot.data;

                  return _FavoriteCityCard(
                    city: city,
                    weather: weather,
                    onTap: () async {
                      if (weather != null) {
                        final weatherProvider = Provider.of<WeatherProvider>(
                          context,
                          listen: false,
                        );

                        await weatherProvider.getWeatherByCoordinates(
                          city.latitude,
                          city.longitude,
                        );

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    onDelete: () {
                      favoritesProvider.removeFavorite(city.name, city.country);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${city.name} removed from favorites'),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 60,
            height: 60,
            color: Colors.white,
          ),
          title: Container(
            height: 16,
            color: Colors.white,
          ),
          subtitle: Container(
            height: 14,
            margin: const EdgeInsets.only(top: 8),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, FavoritesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content:
            const Text('Are you sure you want to remove all favorite cities?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All favorites cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCityCard extends StatelessWidget {
  final dynamic city;
  final Weather? weather;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _FavoriteCityCard({
    required this.city,
    this.weather,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final apiService = WeatherApiService();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: weather != null
            ? CachedNetworkImage(
                imageUrl: apiService.getIconUrl(weather!.icon),
                width: 60,
                height: 60,
              )
            : const Icon(Icons.cloud_off, size: 60),
        title: Text(
          '${city.name}, ${city.country}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: weather != null
            ? Text(
                '${weather!.temperature.round()}°C • ${weather!.description}',
                style: const TextStyle(fontSize: 14),
              )
            : const Text('Weather unavailable'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (weather != null)
              Text(
                '${weather!.temperature.round()}°',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
