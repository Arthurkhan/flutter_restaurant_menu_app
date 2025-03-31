# Flutter Restaurant Menu App

A complete Flutter application for restaurant menu management with both admin and customer interfaces. This app allows restaurant owners to create and manage their digital menus while providing customers with a user-friendly interface to browse menu items.

## Features

### Admin Interface
- Create and manage multiple menus
- Organize items by categories
- Add, edit, and remove menu items
- Customize appearance with theme editor
- Preview menu as customers will see it
- Responsive layouts for different screen sizes

### Customer Interface
- Browse menus and categories
- View detailed item information
- Search and filter menu items
- Optimized for tablet displays
- Multi-language support

## Technology Stack

- **Framework**: Flutter
- **State Management**: Flutter BLoC with Equatable
- **Data Persistence**: SQLite (sqflite), Shared Preferences
- **Networking**: HTTP
- **Image Caching**: Cached Network Image
- **Architecture**: Clean Architecture with Repository Pattern
- **Localization**: Flutter Localization

## Project Structure

```
lib/
├── blocs/           # Business Logic Components
│   ├── menu/        # Menu-related blocs
│   └── theme/       # Theme-related blocs
├── config/          # App configuration
│   ├── constants.dart
│   ├── routes.dart
│   └── themes.dart
├── data/            # Data layer
│   ├── datasources/ # Remote and local data sources
│   ├── models/      # Data models
│   └── repositories/# Repositories
├── presentation/    # UI layer
│   ├── screens/     # App screens
│   │   ├── admin/   # Admin interface screens
│   │   └── customer/# Customer interface screens
│   └── widgets/     # Reusable widgets
├── utils/           # Utility classes and functions
└── main.dart        # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (2.17.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code
- An Android or iOS device/emulator

### Installation

1. Clone this repository
   ```
   git clone https://github.com/Arthurkhan/flutter-restaurant-menu-app.git
   ```

2. Navigate to the project directory
   ```
   cd flutter-restaurant-menu-app
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## Usage

### Admin Mode

1. Access the admin dashboard by tapping on the admin icon in the settings
2. Create a new menu or select an existing one to edit
3. Add categories to organize your menu items
4. Add items to categories with descriptions, prices, and images
5. Preview your menu as customers will see it

### Customer Mode

1. Browse available menus
2. Select a menu to view its categories
3. Tap on a category to see its items
4. View detailed information about each item

## Customization

### Themes

The app includes several built-in themes:
- Light Theme
- Dark Theme
- Restaurant Theme (warm colors)
- Cafe Theme (earthy tones)

You can also create custom themes with:
- Custom primary and accent colors
- Custom font families
- Adjustable border radius and other UI elements

### Localization

The app supports multiple languages including:
- English
- Spanish
- French
- German
- Italian

## Roadmap

- [ ] Add authentication system
- [ ] Implement online synchronization
- [ ] Add order management
- [ ] Implement analytics dashboard
- [ ] Add printing support for physical menus
- [ ] Support for menu item variants and options

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
