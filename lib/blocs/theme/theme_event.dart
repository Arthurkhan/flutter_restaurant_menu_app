part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  
  @override
  List<Object?> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final AppThemeType themeType;
  
  const ThemeChanged(this.themeType);
  
  @override
  List<Object?> get props => [themeType];
}

class CustomThemeChanged extends ThemeEvent {
  final String name;
  final AppThemeType baseThemeType;
  final Color primaryColor;
  final Color secondaryColor;
  final double? borderRadius;
  final String? fontFamily;
  
  const CustomThemeChanged({
    required this.name,
    required this.baseThemeType,
    required this.primaryColor,
    required this.secondaryColor,
    this.borderRadius,
    this.fontFamily,
  });
  
  @override
  List<Object?> get props => [
    name,
    baseThemeType,
    primaryColor,
    secondaryColor,
    borderRadius,
    fontFamily,
  ];
}

class ThemeLoaded extends ThemeEvent {}