import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/theme/theme_bloc.dart';
import '../../../config/themes.dart';

/// Screen that allows users to edit the app theme
class ThemeEditorScreen extends StatefulWidget {
  const ThemeEditorScreen({Key? key}) : super(key: key);

  @override
  _ThemeEditorScreenState createState() => _ThemeEditorScreenState();
}

class _ThemeEditorScreenState extends State<ThemeEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  AppThemeType _selectedBaseTheme = AppThemeType.light;
  Color _primaryColor = Colors.blue;
  Color _secondaryColor = Colors.blueAccent;
  double _borderRadius = 8.0;
  String? _fontFamily;
  
  bool _isCustomizing = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current theme values
    final currentTheme = context.read<ThemeBloc>().state.appTheme;
    _nameController.text = currentTheme.name;
    
    if (currentTheme.isCustom) {
      _isCustomizing = true;
      _selectedBaseTheme = currentTheme.type;
      _primaryColor = currentTheme.theme.primaryColor;
      _secondaryColor = currentTheme.theme.colorScheme.secondary;
      
      // Extract border radius from button theme (approximation)
      final shape = currentTheme.theme.elevatedButtonTheme.style?.shape?.resolve({});
      if (shape is RoundedRectangleBorder) {
        _borderRadius = shape.borderRadius.resolve(TextDirection.ltr)?.topLeft.x ?? 8.0;
      }
      
      _fontFamily = currentTheme.theme.textTheme.bodyLarge?.fontFamily;
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Editor'),
      ),
      body: _isCustomizing ? _buildCustomThemeEditor() : _buildThemeSelector(),
      floatingActionButton: _isCustomizing ? FloatingActionButton(
        onPressed: _saveCustomTheme,
        child: Icon(Icons.save),
        tooltip: 'Save Theme',
      ) : FloatingActionButton(
        onPressed: () {
          setState(() {
            _isCustomizing = true;
            _nameController.text = 'Custom Theme';
          });
        },
        child: Icon(Icons.palette),
        tooltip: 'Create Custom Theme',
      ),
    );
  }
  
  /// Builds the theme selection grid
  Widget _buildThemeSelector() {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        // Light theme
        _buildThemeCard(
          name: 'Light',
          themeType: AppThemeType.light,
          primaryColor: Colors.blue,
          secondaryColor: Colors.blueAccent,
        ),
        
        // Dark theme
        _buildThemeCard(
          name: 'Dark',
          themeType: AppThemeType.dark,
          primaryColor: Colors.blueAccent,
          secondaryColor: Colors.lightBlueAccent,
          isDark: true,
        ),
        
        // Restaurant theme
        _buildThemeCard(
          name: 'Restaurant',
          themeType: AppThemeType.restaurant,
          primaryColor: Colors.deepOrange,
          secondaryColor: Colors.amber,
        ),
        
        // Cafe theme
        _buildThemeCard(
          name: 'Cafe',
          themeType: AppThemeType.cafe,
          primaryColor: Colors.brown,
          secondaryColor: Colors.green[700]!,
        ),
        
        // Custom theme (if available)
        if (context.read<ThemeBloc>().state.appTheme.isCustom)
          _buildThemeCard(
            name: context.read<ThemeBloc>().state.appTheme.name,
            themeType: AppThemeType.custom,
            primaryColor: context.read<ThemeBloc>().state.appTheme.theme.primaryColor,
            secondaryColor: context.read<ThemeBloc>().state.appTheme.theme.colorScheme.secondary,
            isDark: context.read<ThemeBloc>().state.appTheme.theme.brightness == Brightness.dark,
          ),
      ],
    );
  }
  
  /// Builds a theme selection card
  Widget _buildThemeCard({
    required String name,
    required AppThemeType themeType,
    required Color primaryColor,
    required Color secondaryColor,
    bool isDark = false,
  }) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.read<ThemeBloc>().state.appTheme.type == themeType
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (themeType == AppThemeType.custom) {
            // Edit custom theme
            setState(() {
              _isCustomizing = true;
            });
          } else {
            // Apply built-in theme
            context.read<ThemeBloc>().add(ThemeChanged(themeType));
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$name theme applied')),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme preview
            Expanded(
              child: Container(
                width: double.infinity,
                color: isDark ? Colors.grey[850] : Colors.grey[50],
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Primary color
                    Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Secondary color
                    Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Theme name
            Container(
              width: double.infinity,
              color: primaryColor,
              padding: const EdgeInsets.all(12),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Builds the custom theme editor form
  Widget _buildCustomThemeEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Custom Theme',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 24),
            
            // Theme name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Theme Name',
                hintText: 'Enter a name for your theme',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a theme name';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            
            // Base theme selector
            Text(
              'Base Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<AppThemeType>(
              value: _selectedBaseTheme,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.style),
              ),
              items: [
                DropdownMenuItem(
                  value: AppThemeType.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: AppThemeType.dark,
                  child: Text('Dark'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBaseTheme = value;
                  });
                }
              },
            ),
            SizedBox(height: 24),
            
            // Color selectors
            Text(
              'Colors',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            
            // Primary color
            Row(
              children: [
                Text('Primary Color'),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectColor(isPrimary: true),
                  child: Text('Change'),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Secondary color
            Row(
              children: [
                Text('Secondary Color'),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: _secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectColor(isPrimary: false),
                  child: Text('Change'),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // UI customization
            Text(
              'UI Style',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            
            // Border radius
            Row(
              children: [
                Text('Border Radius'),
                SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: _borderRadius,
                    min: 0,
                    max: 24,
                    divisions: 24,
                    label: _borderRadius.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _borderRadius = value;
                      });
                    },
                  ),
                ),
                Container(
                  width: 35,
                  alignment: Alignment.center,
                  child: Text(_borderRadius.round().toString()),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Font selector
            Row(
              children: [
                Text('Font Family'),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _fontFamily,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Default'),
                      ),
                      DropdownMenuItem(
                        value: 'Poppins',
                        child: Text('Poppins'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _fontFamily = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Preview
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      color: _primaryColor,
                      child: Text(
                        'App Bar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Heading',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _selectedBaseTheme == AppThemeType.dark
                            ? Colors.white
                            : Colors.black87,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This is how your text will look with the selected font family.',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedBaseTheme == AppThemeType.dark
                            ? Colors.white70
                            : Colors.black54,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                        ),
                      ),
                      child: Text(
                        'Primary Button',
                        style: TextStyle(fontFamily: _fontFamily),
                      ),
                    ),
                    SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                        ),
                      ),
                      child: Text(
                        'Secondary Button',
                        style: TextStyle(fontFamily: _fontFamily),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            
            // Cancel button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  icon: Icon(Icons.cancel),
                  label: Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      _isCustomizing = false;
                    });
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('Save Theme'),
                  onPressed: _saveCustomTheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Opens a color picker dialog
  void _selectColor({required bool isPrimary}) {
    // Simple color options
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.deepOrange,
      Colors.lightBlue,
      Colors.deepPurple,
      Colors.lightGreen,
      Colors.brown,
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Color'),
        content: Container(
          width: 300,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    if (isPrimary) {
                      _primaryColor = color;
                    } else {
                      _secondaryColor = color;
                    }
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  /// Saves the custom theme
  void _saveCustomTheme() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ThemeBloc>().add(
        CustomThemeChanged(
          name: _nameController.text,
          baseThemeType: _selectedBaseTheme,
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          borderRadius: _borderRadius,
          fontFamily: _fontFamily,
        ),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Custom theme saved')),
      );
      
      setState(() {
        _isCustomizing = false;
      });
    }
  }
}