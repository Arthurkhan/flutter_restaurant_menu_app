import 'package:flutter/material.dart';
import 'dart:async';
import '../../config/routes.dart';
import '../../config/constants.dart';

/// Enhanced splash screen shown when the app starts
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
    
    // Set up timer to navigate after 2.5 seconds
    Timer(
      const Duration(milliseconds: 2500),
      () => _navigateToNextScreen(),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                
                // Enhanced loading indicator
                SizedBox(
                  width: isTablet ? 48 : 40,
                  height: isTablet ? 48 : 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}