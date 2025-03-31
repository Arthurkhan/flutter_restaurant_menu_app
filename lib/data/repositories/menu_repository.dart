import '../models/menu.dart';
import '../datasources/menu_data_source.dart';

/// Repository for handling menu data
class MenuRepository {
  final MenuDataSource _remoteDataSource;
  final MenuDataSource? _localDataSource;

  MenuRepository(this._remoteDataSource, [this._localDataSource]);

  /// Fetches a menu by ID
  Future<Menu> getMenu(String menuId) async {
    try {
      // Try to get from local cache first if available
      if (_localDataSource != null) {
        try {
          final localMenu = await _localDataSource!.getMenu(menuId);
          return localMenu;
        } catch (e) {
          // If local cache fails, continue to remote fetch
        }
      }

      // Fetch from remote source
      final menu = await _remoteDataSource.getMenu(menuId);
      
      // Save to local cache if available
      if (_localDataSource != null) {
        await _localDataSource!.saveMenu(menu);
      }
      
      return menu;
    } catch (e) {
      throw Exception('Failed to load menu: $e');
    }
  }

  /// Fetches all available menus
  Future<List<Menu>> getAllMenus() async {
    try {
      // Try to get from local cache first if available
      if (_localDataSource != null) {
        try {
          final localMenus = await _localDataSource!.getAllMenus();
          return localMenus;
        } catch (e) {
          // If local cache fails, continue to remote fetch
        }
      }

      // Fetch from remote source
      final menus = await _remoteDataSource.getAllMenus();
      
      // Save to local cache if available
      if (_localDataSource != null) {
        for (final menu in menus) {
          await _localDataSource!.saveMenu(menu);
        }
      }
      
      return menus;
    } catch (e) {
      throw Exception('Failed to load menus: $e');
    }
  }

  /// Creates a new menu
  Future<Menu> createMenu(Menu menu) async {
    try {
      final createdMenu = await _remoteDataSource.createMenu(menu);
      
      // Save to local cache if available
      if (_localDataSource != null) {
        await _localDataSource!.saveMenu(createdMenu);
      }
      
      return createdMenu;
    } catch (e) {
      throw Exception('Failed to create menu: $e');
    }
  }

  /// Updates an existing menu
  Future<Menu> updateMenu(Menu menu) async {
    try {
      final updatedMenu = await _remoteDataSource.updateMenu(menu);
      
      // Update in local cache if available
      if (_localDataSource != null) {
        await _localDataSource!.saveMenu(updatedMenu);
      }
      
      return updatedMenu;
    } catch (e) {
      throw Exception('Failed to update menu: $e');
    }
  }

  /// Deletes a menu by ID
  Future<bool> deleteMenu(String menuId) async {
    try {
      final result = await _remoteDataSource.deleteMenu(menuId);
      
      // Delete from local cache if available
      if (_localDataSource != null) {
        await _localDataSource!.deleteMenu(menuId);
      }
      
      return result;
    } catch (e) {
      throw Exception('Failed to delete menu: $e');
    }
  }
}