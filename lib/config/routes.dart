import 'package:flutter/material.dart';
import '../presentation/screens/admin/admin_dashboard_screen.dart';
import '../presentation/screens/admin/menu_editor_screen.dart';
import '../presentation/screens/admin/category_editor_screen.dart';
import '../presentation/screens/admin/item_editor_screen.dart';
import '../presentation/screens/admin/theme_editor_screen.dart';
import '../presentation/screens/customer/menu_list_screen.dart';
import '../presentation/screens/customer/menu_details_screen.dart';
import '../presentation/screens/customer/category_details_screen.dart';
import '../presentation/screens/customer/item_details_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/splash_screen.dart';

/// Class to manage all app routes
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  
  // Admin routes
  static const String adminDashboard = '/admin';
  static const String menuEditor = '/admin/menu';
  static const String menuEditorWithId = '/admin/menu/:id';
  static const String categoryEditor = '/admin/menu/:menuId/category';
  static const String categoryEditorWithId = '/admin/menu/:menuId/category/:id';
  static const String itemEditor = '/admin/menu/:menuId/category/:categoryId/item';
  static const String itemEditorWithId = '/admin/menu/:menuId/category/:categoryId/item/:id';
  static const String themeEditor = '/admin/theme';
  
  // Customer routes
  static const String menuList = '/menus';
  static const String menuDetails = '/menu/:id';
  static const String categoryDetails = '/menu/:menuId/category/:id';
  static const String itemDetails = '/menu/:menuId/category/:categoryId/item/:id';
  
  // Settings
  static const String settings = '/settings';
  
  /// Generate route based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract route parameters if any
    final uri = Uri.parse(settings.name ?? '/');
    final pathSegments = uri.pathSegments;
    
    // Route name with path parameters
    String routeName = settings.name ?? '/';
    
    // Handle specific routes
    if (routeName == splash) {
      return MaterialPageRoute(builder: (_) => SplashScreen());
    }
    
    if (routeName == adminDashboard) {
      return MaterialPageRoute(builder: (_) => AdminDashboardScreen());
    }
    
    if (routeName == menuEditor) {
      return MaterialPageRoute(
        builder: (_) => MenuEditorScreen(menuId: null)
      );
    }
    
    if (routeName == settings) {
      return MaterialPageRoute(builder: (_) => SettingsScreen());
    }
    
    // Handle dynamic routes with path parameters
    
    // Admin routes
    if (routeName.startsWith('/admin/menu/') && pathSegments.length == 3) {
      final menuId = pathSegments[2];
      return MaterialPageRoute(
        builder: (_) => MenuEditorScreen(menuId: menuId)
      );
    }
    
    if (routeName.startsWith('/admin/menu/') && 
        pathSegments.length == 4 && 
        pathSegments[3] == 'category') {
      final menuId = pathSegments[2];
      return MaterialPageRoute(
        builder: (_) => CategoryEditorScreen(
          menuId: menuId,
          categoryId: null,
        )
      );
    }
    
    if (routeName.startsWith('/admin/menu/') && 
        pathSegments.length == 5 && 
        pathSegments[3] == 'category') {
      final menuId = pathSegments[2];
      final categoryId = pathSegments[4];
      return MaterialPageRoute(
        builder: (_) => CategoryEditorScreen(
          menuId: menuId,
          categoryId: categoryId,
        )
      );
    }
    
    if (routeName.startsWith('/admin/menu/') && 
        pathSegments.length == 6 && 
        pathSegments[3] == 'category' &&
        pathSegments[5] == 'item') {
      final menuId = pathSegments[2];
      final categoryId = pathSegments[4];
      return MaterialPageRoute(
        builder: (_) => ItemEditorScreen(
          menuId: menuId,
          categoryId: categoryId,
          itemId: null,
        )
      );
    }
    
    if (routeName.startsWith('/admin/menu/') && 
        pathSegments.length == 7 && 
        pathSegments[3] == 'category' &&
        pathSegments[5] == 'item') {
      final menuId = pathSegments[2];
      final categoryId = pathSegments[4];
      final itemId = pathSegments[6];
      return MaterialPageRoute(
        builder: (_) => ItemEditorScreen(
          menuId: menuId,
          categoryId: categoryId,
          itemId: itemId,
        )
      );
    }
    
    if (routeName == themeEditor) {
      return MaterialPageRoute(builder: (_) => ThemeEditorScreen());
    }
    
    // Customer routes
    if (routeName == menuList) {
      return MaterialPageRoute(builder: (_) => MenuListScreen());
    }
    
    if (routeName.startsWith('/menu/') && pathSegments.length == 2) {
      final menuId = pathSegments[1];
      return MaterialPageRoute(
        builder: (_) => MenuDetailsScreen(menuId: menuId)
      );
    }
    
    if (routeName.startsWith('/menu/') && 
        pathSegments.length == 4 && 
        pathSegments[2] == 'category') {
      final menuId = pathSegments[1];
      final categoryId = pathSegments[3];
      return MaterialPageRoute(
        builder: (_) => CategoryDetailsScreen(
          menuId: menuId,
          categoryId: categoryId,
        )
      );
    }
    
    if (routeName.startsWith('/menu/') && 
        pathSegments.length == 6 && 
        pathSegments[2] == 'category' &&
        pathSegments[4] == 'item') {
      final menuId = pathSegments[1];
      final categoryId = pathSegments[3];
      final itemId = pathSegments[5];
      return MaterialPageRoute(
        builder: (_) => ItemDetailsScreen(
          menuId: menuId,
          categoryId: categoryId,
          itemId: itemId,
        )
      );
    }
    
    // Default route if no match found
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Route not found: $routeName'),
        ),
      ),
    );
  }
}