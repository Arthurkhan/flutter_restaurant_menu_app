import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/menu/menu_bloc.dart';
import '../../../config/constants.dart';
import '../../../config/routes.dart';
import '../../../data/models/menu.dart';
import '../../../utils/image_helper.dart';
import '../../widgets/menu_card.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/responsive_layout.dart';

/// Screen that displays a list of all available menus
class MenuListScreen extends StatefulWidget {
  const MenuListScreen({Key? key}) : super(key: key);

  @override
  _MenuListScreenState createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  @override
  void initState() {
    super.initState();
    // Load all menus when screen is first shown
    context.read<MenuBloc>().add(LoadAllMenus());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menus'),
        centerTitle: true,
        elevation: 2,
        actions: [
          // Settings button
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
          // Admin dashboard button (for easier debugging/development)
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            tooltip: 'Admin Dashboard',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.adminDashboard);
            },
          ),
        ],
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return LoadingView();
          } else if (state is AllMenusLoaded) {
            // Filter active menus only for customer view
            final activeMenus = state.menus.where((menu) => menu.isActive).toList();
            return _buildMenuList(context, activeMenus);
          } else if (state is MenuError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<MenuBloc>().add(LoadAllMenus());
              },
            );
          } else {
            return Center(
              child: Text('Select a menu to view'),
            );
          }
        },
      ),
    );
  }
  
  /// Builds the menu list UI using responsive layout
  Widget _buildMenuList(BuildContext context, List<Menu> menus) {
    if (menus.isEmpty) {
      return _buildEmptyState();
    }
    
    // Use the ResponsiveLayout widget for adaptive UI
    return ResponsiveLayout(
      mobileView: _buildMobileView(menus),
      tabletView: _buildTabletView(menus),
      desktopView: _buildDesktopView(menus),
    );
  }
  
  /// Builds the mobile view with a simple ListView
  Widget _buildMobileView(List<Menu> menus) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: menus.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final menu = menus[index];
        return _buildMenuCard(menu);
      },
    );
  }
  
  /// Builds the tablet view with a 2-column grid
  Widget _buildTabletView(List<Menu> menus) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        return _buildMenuCard(menu);
      },
    );
  }
  
  /// Builds the desktop view with a 3 or 4-column grid
  Widget _buildDesktopView(List<Menu> menus) {
    return ResponsiveLayout.contentConstraints(
      context,
      GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 1400 ? 4 : 3,
          childAspectRatio: 1.1,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          return _buildMenuCard(menu);
        },
      ),
    );
  }
  
  /// Creates a menu card with enhanced visuals
  Widget _buildMenuCard(Menu menu) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.menuDetails.replaceAll(':id', menu.id),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section using ImageHelper
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ImageHelper.getImageWidget(
                    menu.imageUrl.isNotEmpty ? menu.imageUrl : AppConstants.placeholderImagePath,
                  ),
                ),
                if (menu.categories.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '${menu.categories.length} ${menu.categories.length == 1 ? 'category' : 'categories'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Menu details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu name with enhanced typography
                  Text(
                    menu.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  
                  // Menu description
                  Text(
                    menu.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16),
                  
                  // Last updated info
                  Row(
                    children: [
                      Icon(
                        Icons.update,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Updated: ${_formatDate(menu.updatedAt)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Builds the empty state when no menus are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book,
              size: 72,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No active menus available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please check back later or contact the administrator',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  /// Formats a date to a display-friendly string
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return 'Just now';
      }
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}