import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../weather/data/models/weather_model.dart';
import '../../../weather/data/models/air_quality_model.dart';
import 'package:provider/provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

class WeatherDetails extends StatelessWidget {
  final Weather weather;
  final AirQuality? airQuality;

  const WeatherDetails({
    super.key,
    required this.weather,
    this.airQuality,
  });

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Details Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _DetailItem(
                  icon: Icons.thermostat,
                  label: 'Min/Max',
                  value:
                      '${settingsProvider.formatTemperature(weather.tempMin)} / ${settingsProvider.formatTemperature(weather.tempMax)}',
                ),
                _DetailItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${weather.humidity}%',
                ),
                _DetailItem(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: settingsProvider.formatWindSpeed(weather.windSpeed),
                ),
                _DetailItem(
                  icon: Icons.compress,
                  label: 'Pressure',
                  value: '${weather.pressure} hPa',
                ),
                _DetailItem(
                  icon: Icons.visibility,
                  label: 'Visibility',
                  value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                ),
                _DetailItem(
                  icon: Icons.cloud,
                  label: 'Cloudiness',
                  value: '${weather.cloudiness}%',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Sunrise & Sunset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.orange),
                    const SizedBox(height: 4),
                    const Text('Sunrise'),
                    Text(
                      DateFormat('HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            weather.sunrise * 1000),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.nightlight, color: Colors.indigo),
                    const SizedBox(height: 4),
                    const Text('Sunset'),
                    Text(
                      DateFormat('HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            weather.sunset * 1000),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),

            // Air Quality
            if (airQuality != null) ...[
              const Divider(height: 32),
              Text(
                'Air Quality',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getAQIColor(airQuality!.aqi).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      airQuality!.qualityDescription,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getAQIColor(airQuality!.aqi),
                      ),
                    ),
                    Text(
                      'AQI: ${airQuality!.aqi}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getAQIColor(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
