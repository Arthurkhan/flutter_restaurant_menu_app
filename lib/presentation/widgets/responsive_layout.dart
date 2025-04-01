import 'package:flutter/material.dart';
import '../../config/constants.dart';

/// Widget that provides responsive layout based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileView;
  final Widget tabletView;
  final Widget? desktopView;
  
  /// Default constructor with required views for different screen sizes
  const ResponsiveLayout({
    Key? key,
    required this.mobileView,
    required this.tabletView,
    this.desktopView,
  }) : super(key: key);
  
  /// Secondary constructor that takes a builder function for each screen size
  factory ResponsiveLayout.builder({
    required BuildContext context,
    required Widget Function(BuildContext context, BoxConstraints constraints, ScreenSize size) builder,
  }) {
    return ResponsiveLayout(
      mobileView: LayoutBuilder(
        builder: (context, constraints) => builder(context, constraints, ScreenSize.mobile),
      ),
      tabletView: LayoutBuilder(
        builder: (context, constraints) => builder(context, constraints, ScreenSize.tablet),
      ),
      desktopView: LayoutBuilder(
        builder: (context, constraints) => builder(context, constraints, ScreenSize.desktop),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.desktopMinWidth && desktopView != null) {
          return desktopView!;
        } else if (constraints.maxWidth >= AppConstants.tabletMinWidth) {
          return tabletView;
        } else {
          return mobileView;
        }
      },
    );
  }
  
  /// Static method to determine current screen size
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= AppConstants.desktopMinWidth) {
      return ScreenSize.desktop;
    } else if (width >= AppConstants.tabletMinWidth) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.mobile;
    }
  }
  
  /// Static method to apply content width constraints based on screen size
  static Widget contentConstraints(BuildContext context, Widget child) {
    final screenSize = getScreenSize(context);
    
    // Only apply max width constraint on large screens
    if (screenSize == ScreenSize.desktop) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: child,
        ),
      );
    }
    
    return child;
  }
  
  /// Static method to get appropriate padding for different screen sizes
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.desktop:
        return const EdgeInsets.all(AppConstants.paddingXL);
      case ScreenSize.tablet:
        return const EdgeInsets.all(AppConstants.paddingL);
      case ScreenSize.mobile:
        return const EdgeInsets.all(AppConstants.paddingM);
    }
  }
  
  /// Static method to get appropriate spacing for different screen sizes
  static double getResponsiveSpacing(BuildContext context) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.desktop:
        return AppConstants.paddingL;
      case ScreenSize.tablet:
        return AppConstants.paddingM;
      case ScreenSize.mobile:
        return AppConstants.paddingS;
    }
  }
  
  /// Static method to get grid columns count for different screen sizes
  static int getGridColumnCount(BuildContext context) {
    final screenSize = getScreenSize(context);
    final width = MediaQuery.of(context).size.width;
    
    switch (screenSize) {
      case ScreenSize.desktop:
        return width > 1500 ? 4 : 3;
      case ScreenSize.tablet:
        return width > 900 ? 3 : 2;
      case ScreenSize.mobile:
        return 1;
    }
  }
}

/// Enum representing different screen sizes
enum ScreenSize {
  mobile,
  tablet,
  desktop,
}
