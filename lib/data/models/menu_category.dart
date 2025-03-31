import 'package:equatable/equatable.dart';
import 'menu_item.dart';

/// Represents a category of menu items
class MenuCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<MenuItem> items;
  final int displayOrder;
  final bool isVisible;
  final Map<String, dynamic> customFields;

  const MenuCategory({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl = '',
    required this.items,
    this.displayOrder = 0,
    this.isVisible = true,
    this.customFields = const {},
  });

  /// Creates a MenuCategory from JSON data
  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      items: (json['items'] as List?)
          ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      displayOrder: json['displayOrder'] as int? ?? 0,
      isVisible: json['isVisible'] as bool? ?? true,
      customFields: json['customFields'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts MenuCategory to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'items': items.map((e) => e.toJson()).toList(),
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'customFields': customFields,
    };
  }

  /// Creates a copy of MenuCategory with specified changes
  MenuCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<MenuItem>? items,
    int? displayOrder,
    bool? isVisible,
    Map<String, dynamic>? customFields,
  }) {
    return MenuCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      items: items ?? this.items,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
      customFields: customFields ?? this.customFields,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        items,
        displayOrder,
        isVisible,
      ];
}