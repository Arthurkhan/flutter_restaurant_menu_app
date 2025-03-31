import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/menu.dart';

/// Widget that displays a menu card
class MenuCard extends StatelessWidget {
  final Menu menu;
  final Function() onTap;
  final bool showActions;
  final Function()? onEdit;
  final Function()? onDelete;
  
  const MenuCard({
    Key? key,
    required this.menu,
    required this.onTap,
    this.showActions = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: menu.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: menu.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.restaurant_menu,
                          color: Theme.of(context).primaryColor,
                          size: 48,
                        ),
                      ),
                    )
                  : Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.restaurant_menu,
                          color: Theme.of(context).primaryColor,
                          size: 48,
                        ),
                      ),
                    ),
            ),
            
            // Menu details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu name
                  Text(
                    menu.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  
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
                    children: [
                      Icon(
                        Icons.category,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${menu.categories.length} categories',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.restaurant,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${menu.allItems.length} items',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Action buttons (edit/delete) if showActions is true
            if (showActions) ...[
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Edit button
                    if (onEdit != null)
                      IconButton(
                        icon: Icon(Icons.edit),
                        tooltip: 'Edit menu',
                        onPressed: onEdit,
                      ),
                    
                    // Delete button
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(Icons.delete),
                        tooltip: 'Delete menu',
                        color: Colors.red[400],
                        onPressed: () {
                          _showDeleteConfirmationDialog(context);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Shows a confirmation dialog before deleting a menu
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Menu'),
        content: Text('Are you sure you want to delete "${menu.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (onDelete != null) {
                onDelete!();
              }
            },
          ),
        ],
      ),
    );
  }
}