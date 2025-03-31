import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/menu.dart';
import 'menu_data_source.dart';

/// Implementation of MenuDataSource for local storage using SQLite
class LocalMenuDataSource implements MenuDataSource {
  final Database _database;
  final SharedPreferences _preferences;
  
  // Constants for database table and columns
  static const String _menuTable = 'menus';
  static const String _columnId = 'id';
  static const String _columnData = 'data';
  static const String _columnTimestamp = 'timestamp';
  
  // Preference key prefix for caching
  static const String _prefKeyPrefix = 'menu_cache_';

  LocalMenuDataSource({
    required Database database,
    required SharedPreferences preferences,
  })  : _database = database,
        _preferences = preferences;

  /// Initialize the database
  static Future<Database> initDatabase() async {
    return await openDatabase(
      'restaurant_menu.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $_menuTable ('
          '$_columnId TEXT PRIMARY KEY, '
          '$_columnData TEXT, '
          '$_columnTimestamp INTEGER'
          ')',
        );
      },
    );
  }

  @override
  Future<Menu> getMenu(String menuId) async {
    try {
      // Check shared preferences first for faster access
      final cachedData = _preferences.getString('$_prefKeyPrefix$menuId');
      if (cachedData != null) {
        return Menu.fromJson(json.decode(cachedData));
      }
      
      // If not in shared preferences, check the SQLite database
      final List<Map<String, dynamic>> maps = await _database.query(
        _menuTable,
        columns: [_columnData],
        where: '$_columnId = ?',
        whereArgs: [menuId],
      );

      if (maps.isNotEmpty) {
        final menuJson = json.decode(maps.first[_columnData] as String);
        
        // Cache in shared preferences for faster access next time
        await _preferences.setString(
          '$_prefKeyPrefix$menuId',
          maps.first[_columnData] as String,
        );
        
        return Menu.fromJson(menuJson);
      }
      
      throw Exception('Menu not found in local storage');
    } catch (e) {
      throw Exception('Failed to get menu from local storage: $e');
    }
  }

  @override
  Future<List<Menu>> getAllMenus() async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query(_menuTable);
      
      return List.generate(maps.length, (i) {
        final menuJson = json.decode(maps[i][_columnData] as String);
        return Menu.fromJson(menuJson);
      });
    } catch (e) {
      throw Exception('Failed to get menus from local storage: $e');
    }
  }

  @override
  Future<Menu> createMenu(Menu menu) async {
    // In local storage, create and save are the same operation
    await saveMenu(menu);
    return menu;
  }

  @override
  Future<Menu> updateMenu(Menu menu) async {
    // In local storage, update and save are the same operation
    await saveMenu(menu);
    return menu;
  }

  @override
  Future<bool> deleteMenu(String menuId) async {
    try {
      // Remove from shared preferences
      await _preferences.remove('$_prefKeyPrefix$menuId');
      
      // Remove from SQLite database
      final deletedRows = await _database.delete(
        _menuTable,
        where: '$_columnId = ?',
        whereArgs: [menuId],
      );
      
      return deletedRows > 0;
    } catch (e) {
      throw Exception('Failed to delete menu from local storage: $e');
    }
  }

  @override
  Future<void> saveMenu(Menu menu) async {
    try {
      final menuJson = json.encode(menu.toJson());
      
      // Save to SQLite database
      await _database.insert(
        _menuTable,
        {
          _columnId: menu.id,
          _columnData: menuJson,
          _columnTimestamp: DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      // Save to shared preferences for faster access
      await _preferences.setString('$_prefKeyPrefix${menu.id}', menuJson);
    } catch (e) {
      throw Exception('Failed to save menu to local storage: $e');
    }
  }
}