import 'package:flutter/material.dart';

/// Enum for available theme options
enum AppThemeType {
  light,
  dark,
  restaurant,
  cafe,
  custom,
}

/// AppTheme class to manage themes
class AppTheme {
  final ThemeData theme;
  final String name;
  final AppThemeType type;
  final bool isCustom;
  
  const AppTheme({
    required this.theme,
    required this.name,
    required this.type,
    this.isCustom = false,
  });
  
  /// Creates a copy of AppTheme with provided changes
  AppTheme copyWith({
    ThemeData? theme,
    String? name,
    AppThemeType? type,
    bool? isCustom,
  }) {
    return AppTheme(
      theme: theme ?? this.theme,
      name: name ?? this.name,
      type: type ?? this.type,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

/// Class to manage all available themes
class AppThemes {
  // Light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.white,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 2,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ),
    fontFamily: 'Poppins',
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blueAccent,
    colorScheme: ColorScheme.dark(
      primary: Colors.blueAccent,
      secondary: Colors.lightBlueAccent,
      surface: Colors.grey[850]!,
      error: Colors.redAccent,
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.grey[850],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
    ),
    fontFamily: 'Poppins',
  );

  // Restaurant theme
  static final ThemeData restaurantTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepOrange,
    primaryColor: Colors.deepOrange,
    colorScheme: ColorScheme.light(
      primary: Colors.deepOrange,
      secondary: Colors.amber,
      surface: Colors.white,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepOrange,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepOrange[800]),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepOrange[800]),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange[800]),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange[800]),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange[800]),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange[800]),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[800]),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[800]),
    ),
    fontFamily: 'Poppins',
  );

  // Cafe theme
  static final ThemeData cafeTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.brown,
    primaryColor: Colors.brown,
    colorScheme: ColorScheme.light(
      primary: Colors.brown,
      secondary: Colors.green[700]!,
      surface: Colors.white,
      error: Colors.red[700]!,
    ),
    scaffoldBackgroundColor: Color(0xFFF5F5F0),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.brown,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.brown[800]),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown[800]),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown[800]),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.brown[800]),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.brown[800]),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.brown[800]),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.brown[900]),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.brown[900]),
    ),
    fontFamily: 'Poppins',
  );

  // Map of built-in themes
  static final Map<AppThemeType, AppTheme> themes = {
    AppThemeType.light: AppTheme(
      theme: lightTheme,
      name: 'Light',
      type: AppThemeType.light,
    ),
    AppThemeType.dark: AppTheme(
      theme: darkTheme,
      name: 'Dark',
      type: AppThemeType.dark,
    ),
    AppThemeType.restaurant: AppTheme(
      theme: restaurantTheme,
      name: 'Restaurant',
      type: AppThemeType.restaurant,
    ),
    AppThemeType.cafe: AppTheme(
      theme: cafeTheme,
      name: 'Cafe',
      type: AppThemeType.cafe,
    ),
  };
  
  /// Creates a custom theme from a base theme and custom colors
  static AppTheme createCustomTheme({
    required String name,
    required AppThemeType baseThemeType,
    required Color primaryColor,
    required Color secondaryColor,
    double? borderRadius,
    String? fontFamily,
  }) {
    final baseTheme = themes[baseThemeType]!.theme;
    
    final customTheme = baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
      ),
      fontFamily: fontFamily ?? 'Poppins',
    );
    
    return AppTheme(
      theme: customTheme,
      name: name,
      type: AppThemeType.custom,
      isCustom: true,
    );
  }
}