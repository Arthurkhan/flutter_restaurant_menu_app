import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/menu_item.dart';

/// Widget that displays a menu item card
class ItemCard extends StatelessWidget {
  final MenuItem item;
  final Function() onTap;
  final bool showActions;
  final Function()? onEdit;
  final Function()? onDelete;
  
  const ItemCard({
    Key? key,
    required this.item,
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
            // Item image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: item.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.restaurant,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                    )
                  : Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.restaurant,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
            ),
            
            // Item details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item name
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 4),
                  
                  // Price
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  if (item.description.isNotEmpty) ...[
                    SizedBox(height: 4),
                    // Item description
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  SizedBox(height: 8),
                  
                  // Tags / Availability
                  Row(
                    children: [
                      if (item.isAvailable)
                        Chip(
                          label: Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.green,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        )
                      else
                        Chip(
                          label: Text(
                            'Unavailable',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          backgroundColor: Colors.grey[300],
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        ),
                      
                      SizedBox(width: 8),
                      
                      if (item.tags.isNotEmpty)
                        Expanded(
                          child: Text(
                            item.tags.join(', '),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                        tooltip: 'Edit item',
                        onPressed: onEdit,
                      ),
                    
                    // Delete button
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(Icons.delete),
                        tooltip: 'Delete item',
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
  
  /// Shows a confirmation dialog before deleting an item
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"? This action cannot be undone.'),
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