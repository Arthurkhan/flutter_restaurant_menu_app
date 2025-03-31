import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../blocs/menu/menu_bloc.dart';
import '../../../data/models/menu.dart';
import '../../../data/models/menu_category.dart';
import '../../../data/models/menu_item.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/error_view.dart';

/// Screen for creating or editing a menu item
class ItemEditorScreen extends StatefulWidget {
  final String menuId;
  final String categoryId;
  final String? itemId;

  const ItemEditorScreen({
    Key? key,
    required this.menuId,
    required this.categoryId,
    this.itemId,
  }) : super(key: key);

  @override
  _ItemEditorScreenState createState() => _ItemEditorScreenState();
}

class _ItemEditorScreenState extends State<ItemEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _isAvailable = true;
  int _displayOrder = 0;
  
  bool _isEditing = false;
  bool _isLoading = false;
  Menu? _menu;
  MenuCategory? _category;
  MenuItem? _item;
  
  @override
  void initState() {
    super.initState();
    
    _isEditing = widget.itemId != null;
    
    // Load menu data to access category and items
    context.read<MenuBloc>().add(LoadMenu(widget.menuId));
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
  
  /// Finds the category and item and populates form fields
  void _handleMenuLoaded(Menu menu) {
    _menu = menu;
    
    try {
      _category = menu.categories.firstWhere(
        (category) => category.id == widget.categoryId,
      );
      
      if (_isEditing && widget.itemId != null) {
        try {
          _item = _category!.items.firstWhere(
            (item) => item.id == widget.itemId,
          );
          
          // Populate form fields
          _nameController.text = _item!.name;
          _descriptionController.text = _item!.description;
          _priceController.text = _item!.price.toString();
          _imageUrlController.text = _item!.imageUrl;
          _tagsController.text = _item!.tags.join(', ');
          _isAvailable = _item!.isAvailable;
          _displayOrder = _item!.displayOrder;
        } catch (e) {
          // Item not found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Item not found'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop();
        }
      }
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
  
  /// Saves the menu item
  void _saveItem() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      if (_menu == null || _category == null) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu or category not loaded. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Parse price
      double price = 0.0;
      try {
        price = double.parse(_priceController.text);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid price format'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Parse tags
      List<String> tags = [];
      if (_tagsController.text.isNotEmpty) {
        tags = _tagsController.text.split(',').map((tag) => tag.trim()).toList();
      }
      
      if (_isEditing && _item != null) {
        // Update existing item
        final updatedItem = _item!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          price: price,
          imageUrl: _imageUrlController.text,
          tags: tags,
          isAvailable: _isAvailable,
          displayOrder: _displayOrder,
        );
        
        context.read<MenuBloc>().add(
          UpdateMenuItem(
            menuId: widget.menuId,
            categoryId: widget.categoryId,
            item: updatedItem,
          ),
        );
      } else {
        // Create new item
        final newItem = MenuItem(
          id: Uuid().v4(),
          name: _nameController.text,
          description: _descriptionController.text,
          price: price,
          imageUrl: _imageUrlController.text,
          tags: tags,
          isAvailable: _isAvailable,
          displayOrder: _displayOrder,
        );
        
        context.read<MenuBloc>().add(
          AddMenuItem(
            menuId: widget.menuId,
            categoryId: widget.categoryId,
            item: newItem,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Item' : 'Add Item'),
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
            // Menu loaded, find category and item if editing
            _handleMenuLoaded(state.menu);
          }
        },
        builder: (context, state) {
          if (_isLoading) {
            return LoadingView(message: _isEditing ? 'Updating item...' : 'Creating item...');
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
  
  /// Builds the item form
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Item image preview
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
                labelText: 'Item Name',
                hintText: 'Enter item name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an item name';
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
                hintText: 'Enter item description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            
            // Price field
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                hintText: 'Enter price',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                try {
                  double.parse(value);
                } catch (e) {
                  return 'Please enter a valid price';
                }
                return null;
              },
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
            
            // Tags field
            TextFormField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: 'Tags',
                hintText: 'Enter comma-separated tags',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.tag),
              ),
            ),
            SizedBox(height: 16),
            
            // Availability status
            SwitchListTile(
              title: Text('Available'),
              subtitle: Text('Item is available for order'),
              value: _isAvailable,
              onChanged: (value) {
                setState(() {
                  _isAvailable = value;
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
              label: Text(_isEditing ? 'Update Item' : 'Create Item'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _saveItem,
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
}