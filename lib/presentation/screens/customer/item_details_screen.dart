import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/menu/menu_bloc.dart';
import '../../../config/routes.dart';
import '../../../data/models/menu.dart';
import '../../../data/models/menu_category.dart';
import '../../../data/models/menu_item.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

/// Screen that displays the details of a menu item
class ItemDetailsScreen extends StatefulWidget {
  final String menuId;
  final String categoryId;
  final String itemId;

  const ItemDetailsScreen({
    Key? key,
    required this.menuId,
    required this.categoryId,
    required this.itemId,
  }) : super(key: key);

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Load the menu when screen is first shown
    context.read<MenuBloc>().add(LoadMenu(widget.menuId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return LoadingView();
          } else if (state is MenuLoaded && state.menu.id == widget.menuId) {
            // Find the category and item in the menu
            final category = state.menu.getCategoryById(widget.categoryId);
            
            if (category != null) {
              final item = category.items.where((item) => item.id == widget.itemId).firstOrNull;
              
              if (item != null) {
                return _buildItemDetails(context, state.menu, category, item);
              } else {
                return ErrorView(
                  message: 'Item not found',
                  onRetry: () {
                    context.read<MenuBloc>().add(LoadMenu(widget.menuId));
                  },
                );
              }
            } else {
              return ErrorView(
                message: 'Category not found',
                onRetry: () {
                  context.read<MenuBloc>().add(LoadMenu(widget.menuId));
                },
              );
            }
          } else if (state is MenuError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<MenuBloc>().add(LoadMenu(widget.menuId));
              },
            );
          } else {
            return LoadingView();
          }
        },
      ),
    );
  }

  /// Builds the item details UI
  Widget _buildItemDetails(
    BuildContext context, 
    Menu menu, 
    MenuCategory category, 
    MenuItem item
  ) {
    return CustomScrollView(
      slivers: [
        // App bar with item image as background
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(item.name),
            background: item.imageUrl.isNotEmpty
                ? Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Edit item',
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.itemEditorWithId
                      .replaceAll(':menuId', widget.menuId)
                      .replaceAll(':categoryId', widget.categoryId)
                      .replaceAll(':id', widget.itemId),
                );
              },
            ),
            // More actions can be added here
          ],
        ),
        
        // Item details
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price and availability
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(
                        item.isAvailable ? 'Available' : 'Not Available',
                        style: TextStyle(
                          color: item.isAvailable ? Colors.white : Colors.black87,
                        ),
                      ),
                      backgroundColor: item.isAvailable
                          ? Colors.green
                          : Colors.grey[300],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                Text(
                  item.description.isNotEmpty
                      ? item.description
                      : 'No description available',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 24),
                
                // Tags section
                if (item.tags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                ],
                
                // Nutritional information
                if (item.nutritionalInfo.isNotEmpty) ...[
                  Text(
                    'Nutritional Info',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: item.nutritionalInfo.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatNutritionalKey(entry.key),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(entry.value.toString()),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                ],
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.edit),
                      label: Text('Edit'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.itemEditorWithId
                              .replaceAll(':menuId', widget.menuId)
                              .replaceAll(':categoryId', widget.categoryId)
                              .replaceAll(':id', widget.itemId),
                        );
                      },
                    ),
                    OutlinedButton.icon(
                      icon: Icon(Icons.delete),
                      label: Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Formats nutritional info keys for better display
  String _formatNutritionalKey(String key) {
    // Convert camelCase or snake_case to Title Case with spaces
    final formattedKey = key
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .replaceAll('_', ' ')
        .trim();
    
    return formattedKey.substring(0, 1).toUpperCase() + formattedKey.substring(1);
  }

  /// Shows a confirmation dialog before deleting an item
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this item? This action cannot be undone.'),
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
              
              // Delete the item
              context.read<MenuBloc>().add(
                DeleteMenuItem(
                  menuId: widget.menuId,
                  categoryId: widget.categoryId,
                  itemId: widget.itemId,
                ),
              );
              
              // Navigate back to category screen
              Navigator.of(context).popUntil(
                (route) => route.settings.name?.contains('/category/') ?? false,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Extension to add firstOrNull to Iterable, similar to Dart 3 feature
extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}