import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../weather/data/models/forecast_model.dart';
import '../../../weather/data/services/weather_api_service.dart';
import 'package:provider/provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

class ForecastList extends StatelessWidget {
  final WeatherForecast forecast;

  const ForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    // Group forecasts by day
    Map<String, List<ForecastDay>> groupedForecasts = {};

    for (var item in forecast.forecasts.take(8)) {
      String dateKey = DateFormat('yyyy-MM-dd').format(item.date);
      if (!groupedForecasts.containsKey(dateKey)) {
        groupedForecasts[dateKey] = [];
      }
      groupedForecasts[dateKey]!.add(item);
    }

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groupedForecasts.length,
        itemBuilder: (context, index) {
          String dateKey = groupedForecasts.keys.elementAt(index);
          List<ForecastDay> dayForecasts = groupedForecasts[dateKey]!;
          ForecastDay mainForecast = dayForecasts.first;

          return _ForecastCard(forecast: mainForecast);
        },
      ),
    );
  }
}

class _ForecastCard extends StatelessWidget {
  final ForecastDay forecast;

  const _ForecastCard({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final apiService = WeatherApiService();

    return Card(
      margin: const EdgeInsets.only(right: 12),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              DateFormat('EEE').format(forecast.date),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('MMM d').format(forecast.date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            CachedNetworkImage(
              imageUrl: apiService.getIconUrl(forecast.icon),
              width: 50,
              height: 50,
              placeholder: (context, url) => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            Text(
              settingsProvider.formatTemperature(forecast.temperature),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              forecast.main,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
