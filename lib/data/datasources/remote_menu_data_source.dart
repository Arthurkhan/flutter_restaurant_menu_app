import 'dart:convert';
import '../models/menu.dart';
import 'menu_data_source.dart';

/// Implementation of MenuDataSource for remote API (DEPRECATED)
/// NOTE: This class is kept for reference but should not be used.
/// The app now operates in fully offline mode.
class RemoteMenuDataSource implements MenuDataSource {
  final String _baseUrl;

  RemoteMenuDataSource({
    String? baseUrl,
  }) : _baseUrl = baseUrl ?? '';

  @override
  Future<Menu> getMenu(String menuId) async {
    throw Exception('Remote data source is disabled. Use local data source instead.');
  }

  @override
  Future<List<Menu>> getAllMenus() async {
    throw Exception('Remote data source is disabled. Use local data source instead.');
  }

  @override
  Future<Menu> createMenu(Menu menu) async {
    throw Exception('Remote data source is disabled. Use local data source instead.');
  }

  @override
  Future<Menu> updateMenu(Menu menu) async {
    throw Exception('Remote data source is disabled. Use local data source instead.');
  }

  @override
  Future<bool> deleteMenu(String menuId) async {
    throw Exception('Remote data source is disabled. Use local data source instead.');
  }

  @override
  Future<void> saveMenu(Menu menu) async {
    throw Exception('Remote data source is disabled. Use local data source instead.');
  }
}