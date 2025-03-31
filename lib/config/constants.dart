/// App-wide constants
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://api.example.com/v1';
  static const int apiTimeoutSeconds = 30;
  
  // Cache Configuration
  static const int cacheDurationHours = 24;
  
  // UI Configuration
  static const double tabletMinWidth = 600;
  static const double desktopMinWidth = 1200;
  static const double maxContentWidth = 1440;
  
  // Default Padding and Spacing
  static const double paddingXS = 4;
  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
  static const double paddingXL = 32;
  
  // Images
  static const String placeholderImageUrl = 'assets/images/placeholder.png';
  static const String logoUrl = 'assets/images/logo.png';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Localization
  static const String defaultLocale = 'en';
  static const List<String> supportedLocales = ['en', 'es', 'fr', 'de', 'it'];
  
  // Menu Configuration
  static const int maxCategoriesPerMenu = 20;
  static const int maxItemsPerCategory = 50;
  
  AppConstants._(); // Private constructor to prevent instantiation
}