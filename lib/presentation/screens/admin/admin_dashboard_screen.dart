import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/menu/menu_bloc.dart';
import '../../../config/routes.dart';
import '../../../data/models/menu.dart';
import '../../../config/constants.dart';
import '../../widgets/menu_card.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/error_view.dart';

/// Admin dashboard screen for managing menus
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load all menus when screen is first shown
    context.read<MenuBloc>().add(LoadAllMenus());
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppConstants.tabletMinWidth;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
          IconButton(
            icon: Icon(Icons.color_lens),
            tooltip: 'Theme Editor',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.themeEditor);
            },
          ),
        ],
      ),
      body: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is MenuError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
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
              child: Text('Select an option to manage your menus'),
            );
          }
        },
      ),
      // Bottom navigation bar for admin functions
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: Icon(Icons.menu_book),
                tooltip: 'Manage Menus',
                onPressed: () {
                  // Already on this screen
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: Icon(Icons.image),
                tooltip: 'Media Library',
                onPressed: () {
                  // TODO: Navigate to media library
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Media Library - Coming Soon')),
                  );
                },
              ),
            ),
            // Spacer for FAB
            SizedBox(width: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: Icon(Icons.analytics),
                tooltip: 'Analytics',
                onPressed: () {
                  // TODO: Navigate to analytics
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Analytics - Coming Soon')),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: Icon(Icons.account_circle),
                tooltip: 'User Profile',
                onPressed: () {
                  // TODO: Navigate to user profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User Profile - Coming Soon')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // FAB to create a new menu
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.menuEditor);
        },
        child: Icon(Icons.add),
        tooltip: 'Create new menu',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Builds the menu list with admin actions
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
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Create Menu'),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.menuEditor);
              },
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
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          return MenuCard(
            menu: menu,
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.menuEditorWithId.replaceAll(':id', menu.id),
              );
            },
            showActions: true,
            onEdit: () {
              Navigator.of(context).pushNamed(
                AppRoutes.menuEditorWithId.replaceAll(':id', menu.id),
              );
            },
            onDelete: () {
              context.read<MenuBloc>().add(DeleteMenu(menu.id));
            },
          );
        },
      );
    } else {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: menus.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final menu = menus[index];
          return MenuCard(
            menu: menu,
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.menuEditorWithId.replaceAll(':id', menu.id),
              );
            },
            showActions: true,
            onEdit: () {
              Navigator.of(context).pushNamed(
                AppRoutes.menuEditorWithId.replaceAll(':id', menu.id),
              );
            },
            onDelete: () {
              context.read<MenuBloc>().add(DeleteMenu(menu.id));
            },
          );
        },
      );
    }
  }
}