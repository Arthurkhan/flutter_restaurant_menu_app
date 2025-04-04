import 'package:equatable/equatable.dart';

/// Represents a single item on the menu
class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> tags;
  final bool isAvailable;
  final int displayOrder;
  final Map<String, String> translations;
  final Map<String, dynamic> nutritionalInfo;
  final Map<String, dynamic> customFields;
  
  // Added properties for dietary information
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final int spicyLevel; // 0-5 scale where 0 is not spicy, 5 is extremely spicy
  
  // Added properties that were missing and causing errors
  final String? categoryId;
  final bool isSpecial;
  final List<String> allergens;
  final List<Map<String, dynamic>> options;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MenuItem({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.imageUrl = '',
    this.tags = const [],
    this.isAvailable = true,
    this.displayOrder = 0,
    this.translations = const {},
    this.nutritionalInfo = const {},
    this.customFields = const {},
    this.isVegetarian = false,
    this.isVegan = false, 
    this.isGlutenFree = false,
    this.spicyLevel = 0,
    this.categoryId,
    this.isSpecial = false,
    this.allergens = const [],
    this.options = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a MenuItem from JSON data
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String? ?? '',
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
      isAvailable: json['isAvailable'] as bool? ?? true,
      displayOrder: json['displayOrder'] as int? ?? 0,
      translations: (json['translations'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {},
      nutritionalInfo: json['nutritionalInfo'] as Map<String, dynamic>? ?? {},
      customFields: json['customFields'] as Map<String, dynamic>? ?? {},
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      isGlutenFree: json['isGlutenFree'] as bool? ?? false,
      spicyLevel: json['spicyLevel'] as int? ?? 0,
      categoryId: json['categoryId'] as String?,
      isSpecial: json['isSpecial'] as bool? ?? false,
      allergens: (json['allergens'] as List?)?.map((e) => e as String).toList() ?? [],
      options: (json['options'] as List?)?.map((e) => e as Map<String, dynamic>).toList() ?? [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  /// Converts MenuItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'tags': tags,
      'isAvailable': isAvailable,
      'displayOrder': displayOrder,
      'translations': translations,
      'nutritionalInfo': nutritionalInfo,
      'customFields': customFields,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'spicyLevel': spicyLevel,
      'categoryId': categoryId,
      'isSpecial': isSpecial,
      'allergens': allergens,
      'options': options,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Creates a copy of MenuItem with specified changes
  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? tags,
    bool? isAvailable,
    int? displayOrder,
    Map<String, String>? translations,
    Map<String, dynamic>? nutritionalInfo,
    Map<String, dynamic>? customFields,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    int? spicyLevel,
    String? categoryId,
    bool? isSpecial,
    List<String>? allergens,
    List<Map<String, dynamic>>? options,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      isAvailable: isAvailable ?? this.isAvailable,
      displayOrder: displayOrder ?? this.displayOrder,
      translations: translations ?? this.translations,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      customFields: customFields ?? this.customFields,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      spicyLevel: spicyLevel ?? this.spicyLevel,
      categoryId: categoryId ?? this.categoryId,
      isSpecial: isSpecial ?? this.isSpecial,
      allergens: allergens ?? this.allergens,
      options: options ?? this.options,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Gets the localized name for a specific language code
  String getLocalizedName(String languageCode) {
    return translations['name_$languageCode'] ?? name;
  }

  /// Gets the localized description for a specific language code
  String getLocalizedDescription(String languageCode) {
    return translations['description_$languageCode'] ?? description;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        tags,
        isAvailable,
        displayOrder,
        translations,
        nutritionalInfo,
        isVegetarian,
        isVegan,
        isGlutenFree,
        spicyLevel,
        categoryId,
        isSpecial,
        allergens,
        options,
        createdAt,
        updatedAt,
      ];
}