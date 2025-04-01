import 'package:flutter/material.dart';
import 'dart:io';
import '../../data/models/menu.dart';
import '../../config/constants.dart';
import '../../config/routes.dart';

/// Card widget for displaying menu in grid/list
class MenuCard extends StatelessWidget {
  final Menu menu;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isAdmin;

  const MenuCard({
    Key? key,
    required this.menu,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isAdmin = false,
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
        onTap: onTap ?? () {
          Navigator.of(context).pushNamed(
            AppRoutes.menuDetails.replaceAll(':id', menu.id),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Menu image
            _buildImage(),
            
            // Menu details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu name
                  Text(
                    menu.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  
                  // Menu description
                  Text(
                    menu.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  
                  // Menu metadata
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Categories count
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${menu.categories.length} categories',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      
                      // Updated date
                      Row(
                        children: [
                          Icon(
                            Icons.update,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatDate(menu.updatedAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Admin actions
                  if (isAdmin) ...[
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
    return Stack(
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: _getImageWidget(),
        ),
        
        // Active/Inactive badge
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: menu.isActive
                  ? Colors.green.withValues(red: 0, green: 150, blue: 0, alpha: 200)
                  : Colors.red.withValues(red: 200, green: 0, blue: 0, alpha: 200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              menu.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  /// Returns the appropriate image widget based on the image path
  Widget _getImageWidget() {
    final imagePath = menu.imageUrl;
    
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
  
  /// Formats a date to a display-friendly string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}