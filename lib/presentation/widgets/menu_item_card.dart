import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/menu_item.dart';
import '../../config/constants.dart';
import '../../utils/image_helper.dart';

/// Widget to display a menu item with rich visual styling
class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isAdmin;
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '\$');

  MenuItemCard({
    Key? key,
    required this.item,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasImage = item.imageUrl.isNotEmpty;
    
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
            // Item image if available
            if (hasImage)
              SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ImageHelper.getImageWidget(item.imageUrl),
                    if (item.isSpecial)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _buildSpecialBadge(context),
                      ),
                    if (item.isVegetarian || item.allergens.isNotEmpty)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.isVegetarian)
                              _buildInfoBadge(
                                context, 
                                Icons.eco,
                                Colors.green,
                                'Vegetarian',
                              ),
                            if (item.allergens.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: _buildInfoBadge(
                                  context, 
                                  Icons.warning_amber_rounded,
                                  Colors.amber,
                                  'Allergens',
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              
            // Item details
            Padding(
              padding: EdgeInsets.all(hasImage ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for item name and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Badges for non-image cards
                                if (!hasImage && item.isVegetarian)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.eco,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  
                                // Item name
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            
                            // Item special badge for non-image cards
                            if (!hasImage && item.isSpecial)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Special',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Price badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _currencyFormat.format(item.price),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Description
                  if (item.description.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  // Allergens information
                  if (item.allergens.isNotEmpty && !hasImage) ...[
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, 
                          size: 14, 
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Allergens: ${item.allergens.join(', ')}',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  // Options count (if any)
                  if (item.options.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.list_alt,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${item.options.length} option${item.options.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  // Admin actions
                  if (isAdmin && (onEdit != null || onDelete != null)) ...[
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onEdit != null)
                          TextButton.icon(
                            icon: Icon(Icons.edit, size: 16),
                            label: Text('Edit'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size(60, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: onEdit,
                          ),
                        if (onDelete != null)
                          TextButton.icon(
                            icon: Icon(Icons.delete, size: 16),
                            label: Text('Delete'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size(60, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Item'),
                                  content: Text('Are you sure you want to delete "${item.name}"?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        onDelete!();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Builds a special badge with stylized appearance
  Widget _buildSpecialBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 12,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            'Special',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Builds an info badge with icon and tooltip
  Widget _buildInfoBadge(BuildContext context, IconData icon, Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: color,
        ),
      ),
    );
  }
}