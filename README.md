# Flutter Restaurant Menu App

A fully offline Flutter application for restaurant menu management with admin and customer interfaces.

## Features

- **Fully Offline Operation**: No internet connection required for any functionality
- **Local SQLite Database**: Store and retrieve menu data locally 
- **Admin Interface**: Create and manage menus, categories, and items
- **Customer Interface**: Browse menus and view items
- **Theme Support**: Multiple built-in themes with customization options
- **Multilingual Support**: Support for multiple languages

## Usage Instructions

### Image Handling

Since this app works completely offline, images need to be stored locally. There are two ways to include images:

1. **Asset Images**: Add images to the `assets/images/` directory and reference them with the path (e.g., `assets/images/my_image.png`). Remember to run `flutter pub get` after adding new assets.

2. **Local File Images**: Use absolute file paths for images stored on the device (e.g., `/storage/emulated/0/Pictures/menu_image.jpg`).

### Button Colors

If you encounter any issues with button text colors, you can manually set text colors for buttons using:

```dart
ElevatedButton(
  child: Text('Button Text', style: TextStyle(color: Colors.white)),
  onPressed: () {},
)
```

## Development Notes

- The app uses SQLite for data persistence
- All CRUD operations are performed locally
- Images are stored as file paths, not URLs
- For tablet UI, the app is optimized for landscape orientation

## Project Structure

- `lib/blocs/`: BLoC state management
- `lib/config/`: App configuration and constants
- `lib/data/`: Data models, repositories, and sources
- `lib/presentation/`: UI screens and widgets

## Getting Started

1. Ensure Flutter is installed and up to date
2. Clone this repository
3. Run `flutter pub get`
4. Run `flutter run`

## Supported Platforms

- Android
- iOS 
- Windows
- Linux
- macOS (may require additional setup)
