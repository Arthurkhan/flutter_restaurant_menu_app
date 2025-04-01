import 'package:flutter/material.dart';
import 'dart:io';
import '../../data/models/menu_item.dart';
import '../../config/constants.dart';

/// Card widget for displaying a menu item
class ItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isAdmin;
  final bool showActions;

  const ItemCard({
    Key? key,
    required this.item,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isAdmin = false,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Item image
            _buildImage(),
            
            // Item details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item name and price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Expanded(
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      
                      // Price
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(
                            red: Theme.of(context).colorScheme.primary.r,
                            green: Theme.of(context).colorScheme.primary.g,
                            blue: Theme.of(context).colorScheme.primary.b,
                            alpha: 40,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  
                  // Item description
                  if (item.description.isNotEmpty) ...[
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  // Item metadata
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Dietary tags
                      if (item.isVegetarian)
                        _buildTag(
                          context: context,
                          icon: Icons.eco_outlined,
                          label: 'Vegetarian',
                          color: Colors.green,
                        ),
                      
                      if (item.isVegan)
                        _buildTag(
                          context: context,
                          icon: Icons.spa_outlined,
                          label: 'Vegan',
                          color: Colors.green,
                        ),
                      
                      if (item.isGlutenFree)
                        _buildTag(
                          context: context,
                          icon: Icons.grain_outlined,
                          label: 'Gluten-free',
                          color: Colors.amber,
                        ),
                      
                      // Spicy level
                      if (item.spicyLevel > 0)
                        _buildTag(
                          context: context,
                          icon: Icons.whatshot_outlined,
                          label: _getSpicyLevelLabel(item.spicyLevel),
                          color: Colors.deepOrange,
                        ),
                    ],
                  ),
                  
                  // Visibility
                  if (!item.isAvailable) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(red: 200.0, green: 0.0, blue: 0.0, alpha: 200.0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Currently Unavailable',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  
                  // Admin actions
                  if (isAdmin && showActions) ...[
                    SizedBox(height: 16),
                    _buildAdminActions(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Builds the image section of the card
  Widget _buildImage() {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: _getImageWidget(),
    );
  }
  
  /// Returns the appropriate image widget based on the image path
  Widget _getImageWidget() {
    final imagePath = item.imageUrl;
    
    if (imagePath.isEmpty) {
      // Use placeholder if no image
      return Image.asset(
        AppConstants.placeholderImagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else if (imagePath.startsWith('assets/')) {
      // Use asset image
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else if (imagePath.startsWith('/')) {
      // Use local file image
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else {
      // Fallback to placeholder
      return _buildPlaceholder();
    }
  }
  
  /// Builds a placeholder widget
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 48,
          color: Colors.grey[600],
        ),
      ),
    );
  }
  
  /// Builds a tag widget for item attributes
  Widget _buildTag({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(
          red: color.r.toDouble(),
          green: color.g.toDouble(),
          blue: color.b.toDouble(),
          alpha: 40.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Gets the label for spicy level
  String _getSpicyLevelLabel(int level) {
    switch (level) {
      case 1:
        return 'Mild';
      case 2:
        return 'Medium';
      case 3:
        return 'Hot';
      case 4:
        return 'Very Hot';
      case 5:
        return 'Extreme';
      default:
        return 'Not Spicy';
    }
  }
  
  /// Builds admin action buttons (edit/delete)
  Widget _buildAdminActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Edit button
        if (onEdit != null)
          TextButton.icon(
            icon: Icon(Icons.edit),
            label: Text('Edit'),
            onPressed: onEdit,
          ),
        
        // Delete button
        if (onDelete != null)
          TextButton.icon(
            icon: Icon(Icons.delete),
            label: Text('Delete'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: onDelete,
          ),
      ],
    );
  }
}