# Assets Directory

This directory is for storing app assets like images, icons, and animations.

## Structure

- `images/` - App images (logos, backgrounds, etc.)
- `icons/` - Custom icon files
- `animations/` - Lottie animation files
- `fonts/` - Custom font files

## Usage

When you add assets, uncomment the relevant sections in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/animations/
    - assets/icons/
```

Then run:
```bash
flutter pub get
```

## Note

Currently, the app uses:
- Material Icons (built-in)
- OpenWeatherMap icons (from API)
- System fonts

Custom assets are optional for this project.
