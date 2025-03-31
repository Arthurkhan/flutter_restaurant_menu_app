import 'package:equatable/equatable.dart';
import 'menu_category.dart';
import 'menu_item.dart';

/// Represents a complete menu with categories and items
class Menu extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<MenuCategory> categories;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> customFields;

  const Menu({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl = '',
    required this.categories,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.customFields = const {},
  });

  /// Creates a Menu from JSON data
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      categories: (json['categories'] as List?)
          ?.map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      customFields: json['customFields'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts Menu to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'categories': categories.map((e) => e.toJson()).toList(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'customFields': customFields,
    };
  }

  /// Creates a copy of Menu with specified changes
  Menu copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<MenuCategory>? categories,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? customFields,
  }) {
    return Menu(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customFields: customFields ?? this.customFields,
    );
  }

  /// Returns all items across all categories
  List<MenuItem> get allItems {
    return categories.expand((category) => category.items).toList();
  }

  /// Gets a specific category by ID
  MenuCategory? getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Gets a specific item by ID
  MenuItem? getItemById(String itemId) {
    try {
      return allItems.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        categories,
        isActive,
        createdAt,
        updatedAt,
      ];
}