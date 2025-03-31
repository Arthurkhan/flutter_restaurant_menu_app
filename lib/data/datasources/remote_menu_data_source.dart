import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu.dart';
import 'menu_data_source.dart';
import '../../config/constants.dart';

/// Implementation of MenuDataSource for remote API
class RemoteMenuDataSource implements MenuDataSource {
  final http.Client _client;
  final String _baseUrl;

  RemoteMenuDataSource({
    required http.Client client,
    String? baseUrl,
  })  : _client = client,
        _baseUrl = baseUrl ?? AppConstants.apiBaseUrl;

  @override
  Future<Menu> getMenu(String menuId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/menus/$menuId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Menu.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load menu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  @override
  Future<List<Menu>> getAllMenus() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/menus'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> menuJsonList = json.decode(response.body);
        return menuJsonList
            .map((menuJson) => Menu.fromJson(menuJson))
            .toList();
      } else {
        throw Exception('Failed to load menus: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  @override
  Future<Menu> createMenu(Menu menu) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/menus'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(menu.toJson()),
      );

      if (response.statusCode == 201) {
        return Menu.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create menu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  @override
  Future<Menu> updateMenu(Menu menu) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/menus/${menu.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(menu.toJson()),
      );

      if (response.statusCode == 200) {
        return Menu.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update menu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  @override
  Future<bool> deleteMenu(String menuId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/menus/$menuId'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  @override
  Future<void> saveMenu(Menu menu) async {
    // This is a remote data source, so this method is implemented as an update
    await updateMenu(menu);
  }
}