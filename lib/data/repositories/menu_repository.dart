import '../models/menu.dart';
import '../datasources/menu_data_source.dart';

/// Repository for handling menu data
class MenuRepository {
  final MenuDataSource _localDataSource;

  // Remove remote data source dependency
  MenuRepository(this._localDataSource);

  /// Fetches a menu by ID
  Future<Menu> getMenu(String menuId) async {
    try {
      // Get from local storage only
      final localMenu = await _localDataSource.getMenu(menuId);
      return localMenu;
    } catch (e) {
      throw Exception('Failed to load menu: $e');
    }
  }

  /// Fetches all available menus
  Future<List<Menu>> getAllMenus() async {
    try {
      // Get from local storage only
      final localMenus = await _localDataSource.getAllMenus();
      return localMenus;
    } catch (e) {
      throw Exception('Failed to load menus: $e');
    }
  }

  /// Creates a new menu
  Future<Menu> createMenu(Menu menu) async {
    try {
      // Save to local storage only
      await _localDataSource.saveMenu(menu);
      return menu;
    } catch (e) {
      throw Exception('Failed to create menu: $e');
    }
  }

  /// Updates an existing menu
  Future<Menu> updateMenu(Menu menu) async {
    try {
      // Update in local storage only
      await _localDataSource.saveMenu(menu);
      return menu;
    } catch (e) {
      throw Exception('Failed to update menu: $e');
    }
  }

  /// Deletes a menu by ID
  Future<bool> deleteMenu(String menuId) async {
    try {
      // Delete from local storage only
      final result = await _localDataSource.deleteMenu(menuId);
      return result;
    } catch (e) {
      throw Exception('Failed to delete menu: $e');
    }
  }
}
