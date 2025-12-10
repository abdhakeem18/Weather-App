import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../../core/services/cache_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _SectionHeader(title: 'Appearance'),
          Consumer<SettingsProvider>(
            builder: (context, provider, child) {
              return Card(
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Use dark theme'),
                  secondary: Icon(
                    provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                  value: provider.isDarkMode,
                  onChanged: (value) => provider.toggleDarkMode(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Units Section
          _SectionHeader(title: 'Units'),
          Consumer<SettingsProvider>(
            builder: (context, provider, child) {
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.thermostat),
                      title: const Text('Temperature Unit'),
                      subtitle: Text(
                        provider.temperatureUnit == 'celsius'
                            ? 'Celsius (°C)'
                            : 'Fahrenheit (°F)',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _showTemperatureUnitDialog(context, provider);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.air),
                      title: const Text('Wind Speed Unit'),
                      subtitle: Text(
                        provider.windSpeedUnit == 'kmh'
                            ? 'Kilometers per hour (km/h)'
                            : 'Miles per hour (mph)',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _showWindSpeedUnitDialog(context, provider);
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Permissions Section
          _SectionHeader(title: 'Permissions'),
          Consumer<SettingsProvider>(
            builder: (context, provider, child) {
              return Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Location Services'),
                      subtitle: const Text('Allow location access'),
                      secondary: const Icon(Icons.location_on),
                      value: provider.locationEnabled,
                      onChanged: (value) => provider.toggleLocation(),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Data Section
          _SectionHeader(title: 'Data'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_sweep),
                  title: const Text('Clear Cache'),
                  subtitle: const Text('Remove cached weather data'),
                  onTap: () => _showClearCacheDialog(context),
                ),
                const Divider(height: 1),
                Consumer<FavoritesProvider>(
                  builder: (context, provider, child) {
                    return ListTile(
                      leading: const Icon(Icons.favorite),
                      title: const Text('Favorite Cities'),
                      subtitle: Text('${provider.favoritesCount} cities saved'),
                      trailing: provider.favoritesCount > 0
                          ? TextButton(
                              onPressed: () {
                                _showClearFavoritesDialog(context, provider);
                              },
                              child: const Text('Clear All'),
                            )
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          _SectionHeader(title: 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('App Version'),
                  subtitle: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text('Version ${snapshot.data!.version}');
                      }
                      return const Text('1.0.0');
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cloud),
                  title: const Text('Weather Data'),
                  subtitle: const Text('Powered by OpenWeatherMap'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Developer'),
                  subtitle: const Text('Mobile Application Course Work'),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Reset Button
          Consumer<SettingsProvider>(
            builder: (context, provider, child) {
              return ElevatedButton.icon(
                onPressed: () => _showResetDialog(context, provider),
                icon: const Icon(Icons.restore),
                label: const Text('Reset All Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTemperatureUnitDialog(
    BuildContext context,
    SettingsProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Temperature Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Celsius (°C)'),
              value: 'celsius',
              groupValue: provider.temperatureUnit,
              onChanged: (value) {
                provider.setTemperatureUnit(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Fahrenheit (°F)'),
              value: 'fahrenheit',
              groupValue: provider.temperatureUnit,
              onChanged: (value) {
                provider.setTemperatureUnit(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showWindSpeedUnitDialog(
    BuildContext context,
    SettingsProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wind Speed Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Kilometers per hour (km/h)'),
              value: 'kmh',
              groupValue: provider.windSpeedUnit,
              onChanged: (value) {
                provider.setWindSpeedUnit(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Miles per hour (mph)'),
              value: 'mph',
              groupValue: provider.windSpeedUnit,
              onChanged: (value) {
                provider.setWindSpeedUnit(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'Are you sure you want to clear all cached weather data?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final cacheService = CacheService();
              await cacheService.clearCache();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showClearFavoritesDialog(
    BuildContext context,
    FavoritesProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Favorites'),
        content: const Text(
          'Are you sure you want to remove all favorite cities?',
        ),
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

  void _showResetDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to default?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await provider.resetSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset successfully')),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
