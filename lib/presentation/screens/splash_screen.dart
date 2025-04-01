import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/routes.dart';
import '../../config/constants.dart';
import '../../blocs/menu/menu_bloc.dart';
import 'package:path_provider/path_provider.dart';

/// Enhanced splash screen with initial app setup and resource creation
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  
  bool _isInitializing = true;
  String _statusMessage = "Initializing...";
  double _progress = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.9, curve: Curves.easeOut),
      ),
    );
    
    // Start animations
    _animationController.forward();
    
    // Start initialization process
    _initializeApp();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  /// Initialize the app by checking and creating necessary resources
  Future<void> _initializeApp() async {
    try {
      // Update status
      _updateStatus("Checking data directories...", 0.1);
      await _createAppDirectories();
      
      // Check if demo data needs to be loaded
      _updateStatus("Checking for menu data...", 0.3);
      await _checkForExistingMenus();
      
      // Complete initialization
      _updateStatus("Initialization complete!", 1.0);
      
      // Wait for a moment to show completion
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Navigate to menu list screen
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.menuList);
      }
    } catch (e) {
      _updateStatus("Error: ${e.toString()}", 0.0);
      // Show error and retry button
      setState(() {
        _isInitializing = false;
      });
    }
  }
  
  /// Create necessary app directories
  Future<void> _createAppDirectories() async {
    try {
      // Get app documents directory 
      final appDir = await getApplicationDocumentsDirectory();
      
      // Create image storage directory
      final imageDir = Directory('${appDir.path}/menu_images');
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }
      
      // Create export directory
      final exportDir = Directory('${appDir.path}/exports');
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }
      
      await Future.delayed(const Duration(milliseconds: 300)); // Simulated delay
    } catch (e) {
      debugPrint('Error creating app directories: $e');
      rethrow;
    }
  }
  
  /// Check for existing menus and load demo data if needed
  Future<void> _checkForExistingMenus() async {
    try {
      // Get all menus
      final menuBloc = context.read<MenuBloc>();
      menuBloc.add(LoadAllMenus());
      
      // Listen for the response once
      final completer = Completer();
      final subscription = menuBloc.stream.listen((state) {
        if (state is AllMenusLoaded) {
          if (!completer.isCompleted) {
            completer.complete(state.menus);
          }
        } else if (state is MenuError) {
          if (!completer.isCompleted) {
            completer.completeError(state.message);
          }
        }
      });
      
      // Wait for response with timeout
      final menus = await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          subscription.cancel();
          throw TimeoutException('Menu loading timed out');
        },
      );
      
      subscription.cancel();
      
      // Create demo menu if no menus exist
      _updateStatus("Setting up resources...", 0.6);
      
      if (menus.isEmpty) {
        await _createDemoMenu();
      }
      
      await Future.delayed(const Duration(milliseconds: 300)); // Simulated delay
    } catch (e) {
      debugPrint('Error checking for existing menus: $e');
      rethrow;
    }
  }
  
  /// Create a demo menu if no menus exist
  Future<void> _createDemoMenu() async {
    try {
      // TODO: Create demo menu data
      _updateStatus("Creating demo menu...", 0.8);
      await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay
    } catch (e) {
      debugPrint('Error creating demo menu: $e');
      rethrow;
    }
  }
  
  /// Update the status message and progress
  void _updateStatus(String message, double progress) {
    setState(() {
      _statusMessage = message;
      _progress = progress;
    });
  }
  
  /// Navigate to the next screen
  void _navigateToNextScreen() {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.menuList);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= AppConstants.tabletMinWidth;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: child,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo container with enhanced design
                Container(
                  width: isTablet ? 160 : 120,
                  height: isTablet ? 160 : 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      size: isTablet ? 80 : 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                
                // App name with enhanced typography
                Text(
                  'Restaurant Menu App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 32 : 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                
                // App slogan with improved styling
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Create and customize beautiful menus',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 48),
                
                // Progress indicator with status
                _isInitializing 
                    ? Column(
                        children: [
                          SizedBox(
                            width: isTablet ? 240 : 200,
                            child: LinearProgressIndicator(
                              value: _progress > 0 ? _progress : null,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _statusMessage,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            _statusMessage,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isInitializing = true;
                              });
                              _initializeApp();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}