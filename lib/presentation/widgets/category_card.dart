import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/menu_category.dart';

/// Widget that displays a category card
class CategoryCard extends StatelessWidget {
  final MenuCategory category;
  final Function() onTap;
  final bool showActions;
  final Function()? onEdit;
  final Function()? onDelete;
  
  const CategoryCard({
    Key? key,
    required this.category,
    required this.onTap,
    this.showActions = false,
    this.onEdit,
    this.onDelete,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: category.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: category.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.category,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                    )
                  : Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.category,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
            ),
            
            // Category details
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                  
                  if (category.description.isNotEmpty) ...[
                    SizedBox(height: 4),
                    // Category description
                    Text(
                      category.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  SizedBox(height: 8),
                  
                  // Item count
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${category.items.length} items',
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
                        tooltip: 'Edit category',
                        onPressed: onEdit,
                      ),
                    
                    // Delete button
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(Icons.delete),
                        tooltip: 'Delete category',
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
  
  /// Shows a confirmation dialog before deleting a category
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"? This action cannot be undone.'),
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