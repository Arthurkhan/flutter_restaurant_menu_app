import 'package:flutter/material.dart';
import 'dart:io';
import '../../data/models/menu_category.dart';
import '../../config/constants.dart';

/// Card widget for displaying a menu category
class CategoryCard extends StatelessWidget {
  final MenuCategory category;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isAdmin;
  final bool showActions;

  const CategoryCard({
    Key? key,
    required this.category,
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
            // Category image
            _buildImage(),
            
            // Category details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category name
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  
                  // Category description
                  if (category.description.isNotEmpty) ...[
                    Text(
                      category.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  // Category metadata
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Items count
                      Row(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${category.items.length} items',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      
                      // Visibility badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: category.isVisible
                            ? Colors.green.withValues(red: 0.0, green: 150.0, blue: 0.0, alpha: 200.0)
                            : Colors.red.withValues(red: 200.0, green: 0.0, blue: 0.0, alpha: 200.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          category.isVisible ? 'Visible' : 'Hidden',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
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
      height: 130,
      width: double.infinity,
      child: _getImageWidget(),
    );
  }
  
  /// Returns the appropriate image widget based on the image path
  Widget _getImageWidget() {
    final imagePath = category.imageUrl;
    
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
          Icons.category_outlined,
          size: 48,
          color: Colors.grey[600],
        ),
      ),
    );
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