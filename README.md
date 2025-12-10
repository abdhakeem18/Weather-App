# Weather App 🌤️

A comprehensive Flutter weather application that provides real-time weather information, forecasts, and air quality data using the OpenWeatherMap API.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-brightgreen.svg)
![License](https://img.shields.io/badge/License-Educational-yellow.svg)

> **BSC Mobile Application Development - Course Work 1B**
> 
> A complete weather application demonstrating clean architecture, state management, and modern Flutter development practices.

---

## 📚 Documentation Quick Links

| Document | Description | When to Read |
|----------|-------------|--------------|
| **[GETTING_STARTED.md](GETTING_STARTED.md)** | Quick start guide | 👉 **START HERE** |
| **[SETUP.md](SETUP.md)** | Detailed setup instructions | Installation & configuration |
| **[FEATURES.md](FEATURES.md)** | Complete features list | Understanding capabilities |
| **[DOCUMENTATION.md](DOCUMENTATION.md)** | Technical documentation | Deep dive into architecture |
| **[API_KEY_SETUP.md](API_KEY_SETUP.md)** | API configuration guide | Setting up OpenWeatherMap |
| **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** | Quick reference guide | Quick lookups |
| **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** | Requirements compliance | Course requirements |
| **[SUBMISSION_CHECKLIST.md](SUBMISSION_CHECKLIST.md)** | Pre-submission checklist | Before submitting |
| **[FILE_LIST.md](FILE_LIST.md)** | Complete file listing | Project structure |

---

## 📱 Features

### Core Features
- ✅ **Location-Based Weather** - Automatic location detection and weather display
- ✅ **City Search** - Search for weather in any city worldwide
- ✅ **Favorite Cities** - Save up to 10 favorite cities for quick access
- ✅ **5-Day Forecast** - Detailed weather forecast with hourly data
- ✅ **Weather Alerts** - Extreme weather warnings and notifications
- ✅ **Air Quality Monitoring** - Real-time air quality index and pollutant levels
- ✅ **Customizable Settings** - Dark/light theme, unit preferences, and more

### Additional Features
- 🎨 Material Design 3 UI
- 🌓 Dark/Light theme support
- 📊 Temperature trend charts
- 💾 Offline caching
- 🔄 Pull-to-refresh
- ⚡ Fast and responsive
- 🌍 Multi-language support ready

## 🏗️ Architecture

The app follows **Clean Architecture** with a **feature-based folder structure**:

- **Presentation Layer**: UI screens, widgets, and user interactions
- **State Management**: Provider pattern with ChangeNotifier
- **Data Layer**: API services, models, and local storage
- **Core**: Shared utilities, themes, and configurations

## 🛠️ Technology Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.0+ |
| **Language** | Dart 3.0+ |
| **State Management** | Provider |
| **API Client** | HTTP, Dio |
| **Local Storage** | Hive, Shared Preferences |
| **Location** | Geolocator, Geocoding |
| **Charts** | FL Chart |
| **UI Components** | Cached Network Image, Shimmer, SpinKit |

## 📦 Installation

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- OpenWeatherMap API key

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd weather_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Get API Key**
   - Visit [OpenWeatherMap](https://openweathermap.org/api)
   - Sign up and get your free API key

4. **Configure API Key**
   - Open `lib/core/config/app_config.dart`
   - Replace `YOUR_API_KEY_HERE` with your actual API key:
   ```dart
   static const String apiKey = 'your_actual_api_key_here';
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screens

The app consists of 6+ functional screens:

1. **Splash Screen** - App loading with animations
2. **Home Screen** - Current weather, details, and quick forecast
3. **Search Screen** - Search for cities worldwide
4. **Favorites Screen** - Manage favorite cities
5. **Forecast Screen** - Detailed 5-day forecast with charts
6. **Settings Screen** - Customize app preferences

## 🎨 UI/UX Design

### Material Design 3
- Modern card-based layout
- Consistent spacing and elevation
- Color schemes for light/dark themes
- Typography hierarchy
- Smooth animations and transitions

### Design Principles
- **Simplicity**: Clean and intuitive interface
- **Consistency**: Uniform design across all screens
- **Feedback**: Loading states and error messages
- **Accessibility**: High contrast, readable fonts

## 🔧 Configuration

### Android Permissions

The following permissions are required (already configured in AndroidManifest.xml):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## 📊 Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── theme/              # Theme definitions
│   └── services/           # Shared services
├── features/               # Feature modules
│   ├── splash/            # Splash screen
│   ├── home/              # Home screen
│   ├── weather/           # Weather data & logic
│   ├── search/            # Search functionality
│   ├── favorites/         # Favorites management
│   ├── forecast/          # Forecast display
│   └── settings/          # App settings
└── main.dart              # App entry point
```

## 🔌 API Integration

### OpenWeatherMap API

The app integrates with the following endpoints:

- **Current Weather**: `/weather` - Current weather data
- **5-Day Forecast**: `/forecast` - Weather forecast
- **Air Pollution**: `/air_pollution` - Air quality data
- **Geocoding**: `/geo/1.0/direct` - City search

### CRUD Operations

- **Create**: Add favorite cities, cache data
- **Read**: Fetch weather, forecasts, air quality
- **Update**: Refresh data, modify settings
- **Delete**: Remove favorites, clear cache

## 📚 Documentation

Detailed documentation is available in [DOCUMENTATION.md](DOCUMENTATION.md), including:

- Complete architecture overview
- API integration details
- State management explanation
- UI/UX design guidelines
- Performance optimizations
- Testing strategies

## 🧪 Testing

Run tests using:

```bash
flutter test
```

## 🚀 Building

### Debug Build
```bash
flutter build apk --debug
```

### Release Build
```bash
flutter build apk --release
```

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

## 📈 Performance

- **Fast Load Times**: Optimized API calls and caching
- **Smooth Animations**: 60 FPS animations
- **Low Memory**: Efficient state management
- **Offline Support**: Cached data for offline access

## 🎯 Core Requirements Met

✅ **Application Architecture (25 marks)**
- Feature-based folder structure
- Provider state management
- Architecture diagram included

✅ **UI/UX Design (15 marks)**
- Material Design 3 guidelines
- Color schemes and icons
- Wireframes/screenshots included

✅ **API Integration (30 marks)**
- Full CRUD operations
- Multiple API endpoints
- Data parsing and models
- Error handling

✅ **Additional Features**
- 5+ core features implemented
- Third-party libraries (FL Chart, Shimmer, Hive)
- 6 functional screens
- Clean code and best practices

## 📝 Dummy Data

For testing without internet, the app includes:
- Cached weather data (10-minute expiration)
- Default location (Colombo, Sri Lanka)
- Error handling with friendly messages

## 🔐 Environment Variables

Create a `.env` file (optional) for sensitive data:

```
OPENWEATHERMAP_API_KEY=your_api_key_here
```

## 🤝 Contributing

This is an educational project. Contributions, issues, and feature requests are welcome!

## 📄 License

This project is created for educational purposes as part of a BSC Mobile Application Development course.

## 👨‍💻 Developer

- **Course**: BSC Mobile Application Development
- **Assignment**: Course Work 1 - Part B
- **Technology**: Flutter & Dart

## 🙏 Acknowledgments

- [OpenWeatherMap](https://openweathermap.org/) for weather data API
- [Flutter](https://flutter.dev/) for the amazing framework
- Material Design for UI guidelines
- All the open-source contributors

## 📞 Support

For questions or issues:
1. Check the [Documentation](DOCUMENTATION.md)
2. Review the code comments
3. Contact the developer

---

**Made with ❤️ using Flutter**

**Version**: 1.0.0
**Last Updated**: December 2025
