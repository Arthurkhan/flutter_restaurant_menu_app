import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../blocs/menu/menu_bloc.dart';
import '../../../config/routes.dart';
import '../../../data/models/menu.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/error_view.dart';
import 'dart:io';

/// Screen for creating or editing a menu
class MenuEditorScreen extends StatefulWidget {
  final String? menuId;

  const MenuEditorScreen({
    Key? key,
    this.menuId,
  }) : super(key: key);

  @override
  _MenuEditorScreenState createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends State<MenuEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isActive = true;
  
  bool _isEditing = false;
  bool _isLoading = false;
  Menu? _menu;
  
  @override
  void initState() {
    super.initState();
    
    _isEditing = widget.menuId != null;
    
    if (_isEditing) {
      // Load existing menu data
      context.read<MenuBloc>().add(LoadMenu(widget.menuId!));
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
  
  /// Populates form fields with menu data
  void _populateFormFields(Menu menu) {
    _nameController.text = menu.name;
    _descriptionController.text = menu.description;
    _imageUrlController.text = menu.imageUrl;
    _isActive = menu.isActive;
    _menu = menu;
  }
  
  /// Saves the menu
  void _saveMenu() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      if (_isEditing && _menu != null) {
        // Update existing menu
        final updatedMenu = _menu!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          isActive: _isActive,
          updatedAt: DateTime.now(),
        );
        
        context.read<MenuBloc>().add(UpdateMenu(updatedMenu));
      } else {
        // Create new menu
        final newMenu = Menu(
          id: Uuid().v4(),
          name: _nameController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          categories: [],
          isActive: _isActive,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        context.read<MenuBloc>().add(CreateMenu(newMenu));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Menu' : 'Create Menu'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.visibility),
              tooltip: 'Preview',
              onPressed: () {
                if (_menu != null) {
                  Navigator.of(context).pushNamed(
                    AppRoutes.menuDetails.replaceAll(':id', _menu!.id),
                  );
                }
              },
            ),
        ],
      ),
      body: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuOperationSuccess) {
            setState(() {
              _isLoading = false;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            
            // Navigate back to admin dashboard
            Navigator.of(context).pushReplacementNamed(AppRoutes.adminDashboard);
          } else if (state is MenuError) {
            setState(() {
              _isLoading = false;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is MenuLoaded && _isEditing && state.menu.id == widget.menuId) {
            // Populate form with menu data
            _populateFormFields(state.menu);
          }
        },
        builder: (context, state) {
          if (_isLoading) {
            return LoadingView(message: _isEditing ? 'Updating menu...' : 'Creating menu...');
          } else if (state is MenuLoading && _isEditing) {
            return LoadingView(message: 'Loading menu...');
          } else if (state is MenuError && _menu == null && _isEditing) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<MenuBloc>().add(LoadMenu(widget.menuId!));
              },
            );
          } else {
            return _buildForm();
          }
        },
      ),
    );
  }
  
  /// Builds the menu form
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Menu image preview (show placeholder if empty or not found)
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: _imageUrlController.text.isEmpty 
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 48, color: Colors.grey[600]),
                        SizedBox(height: 8),
                        Text('No Image', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  )
                : _buildImageContent(),
            ),
            
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Menu Name',
                hintText: 'Enter menu name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.menu_book),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a menu name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter menu description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            // Image path field (modified for local asset paths)
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image Path',
                hintText: 'Enter local asset path (e.g., assets/images/menu.png)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
                suffixIcon: IconButton(
                  icon: Icon(Icons.refresh),
                  tooltip: 'Preview image',
                  onPressed: () {
                    // Force a rebuild to show the image preview
                    setState(() {});
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Active status
            SwitchListTile(
              title: Text('Active'),
              subtitle: Text('Menu is visible to customers'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            SizedBox(height: 32),
            
            // Categories section (only for editing)
            if (_isEditing && _menu != null) ...[
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              
              if (_menu!.categories.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No categories available',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Add Category'),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.categoryEditor.replaceAll(':menuId', _menu!.id),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              
              // TODO: Add category list/grid here when editing
              
              SizedBox(height: 32),
            ],
            
            // Save button
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text(_isEditing ? 'Update Menu' : 'Create Menu'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _saveMenu,
            ),
            
            SizedBox(height: 16),
            
            // Cancel button
            OutlinedButton(
              child: Text('Cancel'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build the appropriate image content based on the path
  Widget _buildImageContent() {
    final imagePath = _imageUrlController.text;
    
    // Check if it's an asset path
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                SizedBox(height: 8),
                Text('Failed to load image', style: TextStyle(color: Colors.red[300])),
              ],
            ),
          );
        },
      );
    } 
    // Check if it's a local file path
    else if (imagePath.startsWith('/')) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                SizedBox(height: 8),
                Text('Failed to load image', style: TextStyle(color: Colors.red[300])),
              ],
            ),
          );
        },
      );
    } 
    // Display placeholder for other paths (like network URLs)
    else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, size: 48, color: Colors.amber[700]),
            SizedBox(height: 8),
            Text('Network images not supported in offline mode', 
              style: TextStyle(color: Colors.amber[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}