# Flutter Restaurant Menu App

A Flutter application for restaurant menu management with admin and customer interfaces.

## Features

- Display restaurant menu with categories and items
- View detailed item information (allergens, options, etc.)
- Filter menu items by category, allergens, etc.
- Theme customization with several built-in themes
- Image uploads for menu items and categories

## Getting Started

### Prerequisites

- Flutter version 3.0.0 or higher
- Dart SDK version 2.17.0 or higher

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Arthurkhan/flutter_restaurant_menu_app.git
```

2. Navigate to the project directory:
```bash
cd flutter_restaurant_menu_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. If you encounter any package issues (especially with image_picker), try running:
```bash
flutter clean
flutter pub get
flutter pub cache repair
```

5. Run the app:
```bash
flutter run
```

## Code Structure

- `/lib/blocs` - BLoC state management classes
- `/lib/config` - App configuration (themes, routes, constants)
- `/lib/data` - Data layer (models, repositories, services)
- `/lib/presentation` - UI layer (screens, widgets)
- `/lib/utils` - Utility functions and helpers

## Troubleshooting

### Image Picker Issues

If you encounter issues with the `image_picker` package, make sure to:

1. Check if the package is correctly specified in pubspec.yaml
2. Run `flutter clean` and `flutter pub get`
3. For Android: Ensure the required permissions are set in AndroidManifest.xml
4. For iOS: Ensure the required permissions are set in Info.plist

### Database Issues

If you encounter issues with the local database:

1. Make sure you have the latest versions of sqflite and sqflite_common_ffi
2. For desktop platforms (Windows/Linux), ensure sqfliteFfiInit() is called before database operations

## License

This project is licensed under the MIT License - see the LICENSE file for details.
