import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences _preferences;
  static const String _themeTypeKey = 'app_theme_type';
  static const String _customThemeKey = 'custom_theme_data';
  
  ThemeBloc(this._preferences)
      : super(ThemeState(appTheme: AppThemes.themes[AppThemeType.light]!)) {
    on<ThemeLoaded>(_onThemeLoaded);
    on<ThemeChanged>(_onThemeChanged);
    on<CustomThemeChanged>(_onCustomThemeChanged);
  }
  
  void _onThemeLoaded(ThemeLoaded event, Emitter<ThemeState> emit) {
    try {
      // Load saved theme type from preferences
      final savedThemeTypeIndex = _preferences.getInt(_themeTypeKey);
      
      if (savedThemeTypeIndex != null) {
        final themeType = AppThemeType.values[savedThemeTypeIndex];
        
        // If it's a custom theme, load custom theme data
        if (themeType == AppThemeType.custom) {
          // Load custom theme data (simplified, in real app use JSON serialization)
          final customThemeName = _preferences.getString('${_customThemeKey}_name') ?? 'Custom';
          final baseThemeTypeIndex = _preferences.getInt('${_customThemeKey}_baseType') ?? 0;
          final primaryColorValue = _preferences.getInt('${_customThemeKey}_primaryColor') ?? Colors.blue.value;
          final secondaryColorValue = _preferences.getInt('${_customThemeKey}_secondaryColor') ?? Colors.blueAccent.value;
          final borderRadius = _preferences.getDouble('${_customThemeKey}_borderRadius');
          final fontFamily = _preferences.getString('${_customThemeKey}_fontFamily');
          
          final customTheme = AppThemes.createCustomTheme(
            name: customThemeName,
            baseThemeType: AppThemeType.values[baseThemeTypeIndex],
            primaryColor: Color(primaryColorValue),
            secondaryColor: Color(secondaryColorValue),
            borderRadius: borderRadius,
            fontFamily: fontFamily,
          );
          
          emit(ThemeState(appTheme: customTheme));
        } else {
          // Use a predefined theme
          final appTheme = AppThemes.themes[themeType]!;
          emit(ThemeState(appTheme: appTheme));
        }
      } else {
        // Default to light theme if no saved theme
        emit(ThemeState(appTheme: AppThemes.themes[AppThemeType.light]!));
      }
    } catch (e) {
      // If anything goes wrong, use the default theme
      emit(ThemeState(appTheme: AppThemes.themes[AppThemeType.light]!));
    }
  }
  
  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    final appTheme = AppThemes.themes[event.themeType];
    if (appTheme != null) {
      // Save theme preference
      _preferences.setInt(_themeTypeKey, event.themeType.index);
      emit(ThemeState(appTheme: appTheme));
    }
  }
  
  void _onCustomThemeChanged(CustomThemeChanged event, Emitter<ThemeState> emit) {
    try {
      final customTheme = AppThemes.createCustomTheme(
        name: event.name,
        baseThemeType: event.baseThemeType,
        primaryColor: event.primaryColor,
        secondaryColor: event.secondaryColor,
        borderRadius: event.borderRadius,
        fontFamily: event.fontFamily,
      );
      
      // Save custom theme preferences
      _preferences.setInt(_themeTypeKey, AppThemeType.custom.index);
      _preferences.setString('${_customThemeKey}_name', event.name);
      _preferences.setInt('${_customThemeKey}_baseType', event.baseThemeType.index);
      _preferences.setInt('${_customThemeKey}_primaryColor', event.primaryColor.value);
      _preferences.setInt('${_customThemeKey}_secondaryColor', event.secondaryColor.value);
      
      if (event.borderRadius != null) {
        _preferences.setDouble('${_customThemeKey}_borderRadius', event.borderRadius!);
      } else {
        _preferences.remove('${_customThemeKey}_borderRadius');
      }
      
      if (event.fontFamily != null) {
        _preferences.setString('${_customThemeKey}_fontFamily', event.fontFamily!);
      } else {
        _preferences.remove('${_customThemeKey}_fontFamily');
      }
      
      emit(ThemeState(appTheme: customTheme));
    } catch (e) {
      // If custom theme creation fails, fall back to light theme
      emit(ThemeState(appTheme: AppThemes.themes[AppThemeType.light]!));
    }
  }
}