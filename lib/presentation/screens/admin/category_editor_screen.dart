import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../blocs/menu/menu_bloc.dart';
import '../../../config/routes.dart';
import '../../../data/models/menu.dart';
import '../../../data/models/menu_category.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/error_view.dart';

/// Screen for creating or editing a menu category
class CategoryEditorScreen extends StatefulWidget {
  final String menuId;
  final String? categoryId;

  const CategoryEditorScreen({
    Key? key,
    required this.menuId,
    this.categoryId,
  }) : super(key: key);

  @override
  _CategoryEditorScreenState createState() => _CategoryEditorScreenState();
}

class _CategoryEditorScreenState extends State<CategoryEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isVisible = true;
  int _displayOrder = 0;
  
  bool _isEditing = false;
  bool _isLoading = false;
  Menu? _menu;
  MenuCategory? _category;
  
  @override
  void initState() {
    super.initState();
    
    _isEditing = widget.categoryId != null;
    
    // Load menu data to access or add categories
    context.read<MenuBloc>().add(LoadMenu(widget.menuId));
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
  
  /// Finds the category and populates form fields 
  void _handleMenuLoaded(Menu menu) {
    _menu = menu;
    
    if (_isEditing && widget.categoryId != null) {
      try {
        _category = menu.categories.firstWhere(
          (category) => category.id == widget.categoryId,
        );
        
        // Populate form fields
        _nameController.text = _category!.name;
        _descriptionController.text = _category!.description;
        _imageUrlController.text = _category!.imageUrl;
        _isVisible = _category!.isVisible;
        _displayOrder = _category!.displayOrder;
      } catch (e) {
        // Category not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category not found'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }
  
  /// Saves the category
  void _saveCategory() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      if (_menu == null) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu not loaded. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (_isEditing && _category != null) {
        // Update existing category
        final updatedCategory = _category!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          isVisible: _isVisible,
          displayOrder: _displayOrder,
        );
        
        context.read<MenuBloc>().add(
          UpdateCategory(
            menuId: widget.menuId,
            category: updatedCategory,
          ),
        );
      } else {
        // Create new category
        final newCategory = MenuCategory(
          id: Uuid().v4(),
          name: _nameController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          items: [],
          isVisible: _isVisible,
          displayOrder: _displayOrder,
        );
        
        context.read<MenuBloc>().add(
          AddCategory(
            menuId: widget.menuId,
            category: newCategory,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Category' : 'Add Category'),
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
            
            // Navigate back
            Navigator.of(context).pop();
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
          } else if (state is MenuLoaded && state.menu.id == widget.menuId) {
            // Menu loaded, find category if editing
            _handleMenuLoaded(state.menu);
          }
        },
        builder: (context, state) {
          if (_isLoading) {
            return LoadingView(message: _isEditing ? 'Updating category...' : 'Creating category...');
          } else if (state is MenuLoading) {
            return LoadingView(message: 'Loading menu...');
          } else if (state is MenuError && _menu == null) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<MenuBloc>().add(LoadMenu(widget.menuId));
              },
            );
          } else {
            return _buildForm();
          }
        },
      ),
    );
  }
  
  /// Builds the category form
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category image preview
            if (_imageUrlController.text.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(_imageUrlController.text),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                hintText: 'Enter category name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category name';
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
                hintText: 'Enter category description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            
            // Image URL field
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                hintText: 'Enter image URL',
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
            
            // Visibility status
            SwitchListTile(
              title: Text('Visible'),
              subtitle: Text('Category is visible to customers'),
              value: _isVisible,
              onChanged: (value) {
                setState(() {
                  _isVisible = value;
                });
              },
            ),
            SizedBox(height: 16),
            
            // Display order
            Row(
              children: [
                Expanded(
                  child: Text('Display Order'),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_displayOrder > 0) {
                        _displayOrder--;
                      }
                    });
                  },
                ),
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    '$_displayOrder',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _displayOrder++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            
            // Save button
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text(_isEditing ? 'Update Category' : 'Create Category'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _saveCategory,
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
            
            // Items section (only for editing)
            if (_isEditing && _category != null) ...[
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu Items',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Add Item'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.itemEditor
                            .replaceAll(':menuId', widget.menuId)
                            .replaceAll(':categoryId', widget.categoryId!),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              
              if (_category!.items.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No items available',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Add Item'),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.itemEditor
                                  .replaceAll(':menuId', widget.menuId)
                                  .replaceAll(':categoryId', widget.categoryId!),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              
              // TODO: Add items list/grid here when editing
            ],
          ],
        ),
      ),
    );
  }
}