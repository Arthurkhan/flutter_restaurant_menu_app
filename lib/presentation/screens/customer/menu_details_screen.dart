import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/menu/menu_bloc.dart';
import '../../../config/constants.dart';
import '../../../config/routes.dart';
import '../../../data/models/menu.dart';
import '../../../data/models/menu_category.dart';
import '../../widgets/category_card.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

/// Screen that displays the details of a menu and its categories
class MenuDetailsScreen extends StatefulWidget {
  final String menuId;

  const MenuDetailsScreen({
    Key? key,
    required this.menuId,
  }) : super(key: key);

  @override
  _MenuDetailsScreenState createState() => _MenuDetailsScreenState();
}

class _MenuDetailsScreenState extends State<MenuDetailsScreen> {
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
            return _buildMenuDetails(context, state.menu, isTablet);
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
      // FAB to add a new category (only visible in admin mode)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.categoryEditor.replaceAll(':menuId', widget.menuId),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add category',
      ),
    );
  }

  /// Builds the menu details UI
  Widget _buildMenuDetails(BuildContext context, Menu menu, bool isTablet) {
    return CustomScrollView(
      slivers: [
        // App bar with menu image as background
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(menu.name),
            background: menu.imageUrl.isNotEmpty
                ? Image.network(
                    menu.imageUrl,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Edit menu',
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.menuEditorWithId.replaceAll(':id', menu.id),
                );
              },
            ),
            // More actions can be added here
          ],
        ),
        
        // Menu description
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
                  menu.description,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 16),
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
        
        // Categories grid or list
        if (menu.categories.isEmpty)
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No categories available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Add Category'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.categoryEditor.replaceAll(':menuId', menu.id),
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
              ? _buildCategoriesGrid(context, menu.categories, menu.id)
              : _buildCategoriesList(context, menu.categories, menu.id),
      ],
    );
  }

  /// Builds a grid layout for categories on tablet devices
  Widget _buildCategoriesGrid(
    BuildContext context,
    List<MenuCategory> categories,
    String menuId,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > AppConstants.desktopMinWidth ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.categoryDetails
                      .replaceAll(':menuId', menuId)
                      .replaceAll(':id', category.id),
                );
              },
              showActions: true,
              onEdit: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.categoryEditorWithId
                      .replaceAll(':menuId', menuId)
                      .replaceAll(':id', category.id),
                );
              },
              onDelete: () {
                context.read<MenuBloc>().add(
                  DeleteCategory(
                    menuId: menuId,
                    categoryId: category.id,
                  ),
                );
              },
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }

  /// Builds a list layout for categories on phone devices
  Widget _buildCategoriesList(
    BuildContext context,
    List<MenuCategory> categories,
    String menuId,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CategoryCard(
              category: category,
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.categoryDetails
                      .replaceAll(':menuId', menuId)
                      .replaceAll(':id', category.id),
                );
              },
              showActions: true,
              onEdit: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.categoryEditorWithId
                      .replaceAll(':menuId', menuId)
                      .replaceAll(':id', category.id),
                );
              },
              onDelete: () {
                context.read<MenuBloc>().add(
                  DeleteCategory(
                    menuId: menuId,
                    categoryId: category.id,
                  ),
                );
              },
            ),
          );
        },
        childCount: categories.length,
      ),
    );
  }
}