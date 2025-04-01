import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../config/themes.dart';

/// A widget that displays theme selection options with previews
class ThemeSelector extends StatelessWidget {
  final bool isTablet;
  final bool showTitle;
  
  const ThemeSelector({
    Key? key,
    this.isTablet = false,
    this.showTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentThemeState = context.watch<ThemeBloc>().state;
    final currentTheme = currentThemeState.appTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Select Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
        
        // Grid of theme options
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 3 : 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: AppThemes.themes.length,
          itemBuilder: (context, index) {
            final themeType = AppThemes.themes.keys.elementAt(index);
            final theme = AppThemes.themes[themeType]!;
            
            // Skip custom theme in the grid
            if (themeType == AppThemeType.custom) return SizedBox();
            
            return ThemePreviewCard(
              theme: theme,
              isSelected: currentTheme.type == themeType,
              onTap: () {
                context.read<ThemeBloc>().add(ThemeChanged(themeType));
              },
            );
          },
        ),
        
        SizedBox(height: 24),
        
        // Custom theme button
        OutlinedButton.icon(
          icon: Icon(Icons.palette),
          label: Text('Customize Theme'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onPressed: () {
            _showCustomThemeDialog(context);
          },
        ),
      ],
    );
  }
  
  void _showCustomThemeDialog(BuildContext context) {
    final currentThemeState = context.read<ThemeBloc>().state;
    final currentTheme = currentThemeState.appTheme;
    
    // Starting values for the custom theme
    AppThemeType baseThemeType = currentTheme.type == AppThemeType.custom 
        ? AppThemeType.light // Default base theme
        : currentTheme.type;
    Color primaryColor = currentTheme.primaryColor;
    Color secondaryColor = currentTheme.accentColor;
    String themeName = 'Custom Theme';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Customize Theme'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theme name input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Theme Name',
                      hintText: 'Enter a name for your custom theme',
                    ),
                    initialValue: themeName,
                    onChanged: (value) {
                      themeName = value;
                    },
                  ),
                  SizedBox(height: 16),
                  
                  // Base theme selection
                  Text(
                    'Base Theme',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<AppThemeType>(
                    value: baseThemeType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    items: [
                      AppThemeType.light,
                      AppThemeType.dark,
                    ].map((type) {
                      return DropdownMenuItem<AppThemeType>(
                        value: type,
                        child: Text(AppThemes.getThemeName(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          baseThemeType = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  
                  // Primary color picker
                  Text(
                    'Primary Color',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  _buildColorPicker(
                    context, 
                    primaryColor, 
                    (color) {
                      setState(() {
                        primaryColor = color;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  
                  // Secondary color picker
                  Text(
                    'Secondary Color',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  _buildColorPicker(
                    context, 
                    secondaryColor, 
                    (color) {
                      setState(() {
                        secondaryColor = color;
                      });
                    },
                  ),
                  
                  SizedBox(height: 16),
                  Text(
                    'Preview',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  
                  // Preview of custom theme
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                        ),
                        onPressed: null,
                        child: Text(
                          'Preview Button',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Apply'),
                onPressed: () {
                  context.read<ThemeBloc>().add(
                    CustomThemeChanged(
                      name: themeName,
                      baseThemeType: baseThemeType,
                      primaryColor: primaryColor,
                      secondaryColor: secondaryColor,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildColorPicker(
    BuildContext context, 
    Color currentColor, 
    Function(Color) onColorChanged
  ) {
    // List of predefined colors
    final List<Color> colorOptions = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];
    
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: colorOptions.map((color) {
        final isSelected = currentColor.value == color.value;
        
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: isSelected 
              ? Icon(Icons.check, color: Colors.white, size: 20)
              : null,
          ),
        );
      }).toList(),
    );
  }
}

/// Card widget that displays a preview of a theme
class ThemePreviewCard extends StatelessWidget {
  final AppTheme theme;
  final bool isSelected;
  final VoidCallback onTap;
  
  const ThemePreviewCard({
    Key? key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isSelected ? 5 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme preview
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      // UI Preview elements
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App bar
                          Container(
                            width: double.infinity,
                            height: 24,
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 30,
                                  height: 8,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Container(
                                  width: 60,
                                  height: 8,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                SizedBox(height: 8),
                                
                                // Items
                                for (int i = 0; i < 3; i++) ...[
                                  Container(
                                    width: double.infinity,
                                    height: 16,
                                    margin: EdgeInsets.only(bottom: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                                
                                SizedBox(height: 8),
                                
                                // Button
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 60,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: theme.accentColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // Selected overlay
                      if (isSelected)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Theme name
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  theme.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Theme type
              Text(
                theme.isDark ? 'Dark Theme' : 'Light Theme',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}