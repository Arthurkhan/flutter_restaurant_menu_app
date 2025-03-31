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
      ];
}