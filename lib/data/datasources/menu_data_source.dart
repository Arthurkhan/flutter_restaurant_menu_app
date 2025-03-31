import '../models/menu.dart';

/// Abstract class for menu data sources (both remote and local)
abstract class MenuDataSource {
  /// Fetches a menu by ID
  Future<Menu> getMenu(String menuId);
  
  /// Fetches all menus
  Future<List<Menu>> getAllMenus();
  
  /// Creates a new menu
  Future<Menu> createMenu(Menu menu);
  
  /// Updates an existing menu
  Future<Menu> updateMenu(Menu menu);
  
  /// Deletes a menu by ID
  Future<bool> deleteMenu(String menuId);
  
  /// Saves a menu to the data source
  Future<void> saveMenu(Menu menu);
}