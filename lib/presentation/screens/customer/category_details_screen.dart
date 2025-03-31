import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/menu/menu_bloc.dart';
import '../../../config/constants.dart';
import '../../../config/routes.dart';
import '../../../data/models/menu.dart';
import '../../../data/models/menu_category.dart';
import '../../../data/models/menu_item.dart';
import '../../widgets/item_card.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

/// Screen that displays the details of a category and its menu items
class CategoryDetailsScreen extends StatefulWidget {
  final String menuId;
  final String categoryId;

  const CategoryDetailsScreen({
    Key? key,
    required this.menuId,
    required this.categoryId,
  }) : super(key: key);

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Load the menu when screen is first shown
    context.read<MenuBloc>().add(LoadMenu(widget.menuId));
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we're on a tablet-sized device
    final isTablet = MediaQuery.of(context).size.width >= AppConstants.tabletMinWidth;

    return Scaffold(
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return LoadingView();
          } else if (state is MenuLoaded && state.menu.id == widget.menuId) {
            // Find the category in the menu
            final category = state.menu.getCategoryById(widget.categoryId);
            
            if (category != null) {
              return _buildCategoryDetails(context, state.menu, category, isTablet);
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
      // FAB to add a new item (only visible in admin mode)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.itemEditor.replaceAll(':menuId', widget.menuId).replaceAll(':categoryId', widget.categoryId),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add item',
      ),
    );
  }

  /// Builds the category details UI
  Widget _buildCategoryDetails(
    BuildContext context, 
    Menu menu, 
    MenuCategory category, 
    bool isTablet
  ) {
    return CustomScrollView(
      slivers: [
        // App bar with category image as background
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(category.name),
            background: category.imageUrl.isNotEmpty
                ? Image.network(
                    category.imageUrl,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Icon(
                        Icons.category,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Edit category',
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.categoryEditorWithId
                      .replaceAll(':menuId', widget.menuId)
                      .replaceAll(':id', widget.categoryId),
                );
              },
            ),
            // More actions can be added here
          ],
        ),
        
        // Category description
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8),
                Text(
                  category.description.isNotEmpty
                      ? category.description
                      : 'No description available',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 16),
                Text(
                  'Menu Items',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
        
        // Menu items grid or list
        if (category.items.isEmpty)
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No items available in this category',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Add Item'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.itemEditor
                              .replaceAll(':menuId', widget.menuId)
                              .replaceAll(':categoryId', widget.categoryId),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          isTablet
              ? _buildItemsGrid(context, category.items, menu.id, category.id)
              : _buildItemsList(context, category.items, menu.id, category.id),
      ],
    );
  }

  /// Builds a grid layout for menu items on tablet devices
  Widget _buildItemsGrid(
    BuildContext context,
    List<MenuItem> items,
    String menuId,
    String categoryId,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > AppConstants.desktopMinWidth ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = items[index];
            return _buildItemCard(context, item, menuId, categoryId);
          },
          childCount: items.length,
        ),
      ),
    );
  }

  /// Builds a list layout for menu items on phone devices
  Widget _buildItemsList(
    BuildContext context,
    List<MenuItem> items,
    String menuId,
    String categoryId,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildItemCard(context, item, menuId, categoryId),
          );
        },
        childCount: items.length,
      ),
    );
  }

  /// Builds a card for a menu item
  Widget _buildItemCard(
    BuildContext context,
    MenuItem item,
    String menuId,
    String categoryId,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.itemDetails
                .replaceAll(':menuId', menuId)
                .replaceAll(':categoryId', categoryId)
                .replaceAll(':itemId', item.id),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image
            Expanded(
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      width: double.infinity,
                      child: Center(
                        child: Icon(
                          Icons.restaurant,
                          color: Theme.of(context).primaryColor,
                          size: 48,
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
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontSize: 16,
                    ),
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
                      fontSize: 16,
                    ),
                  ),
                  
                  // Brief description
                  if (item.description.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}