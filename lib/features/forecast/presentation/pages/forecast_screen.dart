import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../weather/data/models/forecast_model.dart';
import '../../../weather/data/services/weather_api_service.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Day Forecast'),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.forecast == null) {
            return const Center(
              child: Text('No forecast data available'),
            );
          }

          final forecast = weatherProvider.forecast!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // City Info
                Text(
                  '${forecast.cityName}, ${forecast.country}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                // Temperature Chart
                _TemperatureChart(forecasts: forecast.forecasts),

                const SizedBox(height: 24),

                Text(
                  'Detailed Forecast',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),

                // Forecast List
                ...forecast.forecasts.take(20).map((item) {
                  return _ForecastItem(forecast: item);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TemperatureChart extends StatelessWidget {
  final List<ForecastDay> forecasts;

  const _TemperatureChart({required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temperature Trend',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}°',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= forecasts.length) {
                            return const Text('');
                          }
                          final date = forecasts[value.toInt()].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('HH:mm').format(date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: forecasts
                          .asMap()
                          .entries
                          .take(8)
                          .map((entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.temperature,
                              ))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastItem extends StatelessWidget {
  final ForecastDay forecast;

  const _ForecastItem({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final apiService = WeatherApiService();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: apiService.getIconUrl(forecast.icon),
          width: 50,
          height: 50,
        ),
        title: Text(
          DateFormat('EEE, MMM d - HH:mm').format(forecast.date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(forecast.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.water_drop, size: 14, color: Colors.blue),
                const SizedBox(width: 4),
                Text('${(forecast.pop * 100).toInt()}%'),
                const SizedBox(width: 16),
                Icon(Icons.air, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(settingsProvider.formatWindSpeed(forecast.windSpeed)),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              settingsProvider.formatTemperature(forecast.temperature),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${settingsProvider.formatTemperature(forecast.tempMin)} - ${settingsProvider.formatTemperature(forecast.tempMax)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
