import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/menu/menu_bloc.dart';
import '../../../config/constants.dart';
import '../../../config/routes.dart';
import '../../../data/models/menu.dart';
import '../../widgets/menu_card.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

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
    // Determine if we're on a tablet-sized device
    final isTablet = MediaQuery.of(context).size.width >= AppConstants.tabletMinWidth;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Menus'),
        actions: [
          // Settings button
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
          // Admin dashboard button (for easier debugging/development)
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
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
            return _buildMenuList(context, state.menus, isTablet);
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
  
  /// Builds the menu list UI
  Widget _buildMenuList(BuildContext context, List<Menu> menus, bool isTablet) {
    if (menus.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 72,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No menus available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    // Filter active menus only for customer view
    final activeMenus = menus.where((menu) => menu.isActive).toList();
    
    if (activeMenus.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 72,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No active menus available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    // Use a grid layout for tablets, list for phones
    if (isTablet) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > AppConstants.desktopMinWidth ? 3 : 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: activeMenus.length,
        itemBuilder: (context, index) {
          final menu = activeMenus[index];
          return MenuCard(
            menu: menu,
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.menuDetails.replaceAll(':id', menu.id),
              );
            },
          );
        },
      );
    } else {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: activeMenus.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final menu = activeMenus[index];
          return MenuCard(
            menu: menu,
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.menuDetails.replaceAll(':id', menu.id),
              );
            },
          );
        },
      );
    }
  }
}