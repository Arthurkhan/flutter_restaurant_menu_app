import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/menu.dart';
import '../../data/models/menu_category.dart';
import '../../data/models/menu_item.dart';
import '../../data/repositories/menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _menuRepository;
  
  MenuBloc(this._menuRepository) : super(MenuInitial()) {
    on<LoadMenu>(_onLoadMenu);
    on<LoadAllMenus>(_onLoadAllMenus);
    on<CreateMenu>(_onCreateMenu);
    on<UpdateMenu>(_onUpdateMenu);
    on<DeleteMenu>(_onDeleteMenu);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<AddMenuItem>(_onAddMenuItem);
    on<UpdateMenuItem>(_onUpdateMenuItem);
    on<DeleteMenuItem>(_onDeleteMenuItem);
  }
  
  Future<void> _onLoadMenu(LoadMenu event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final menu = await _menuRepository.getMenu(event.menuId);
      emit(MenuLoaded(menu));
    } catch (e) {
      emit(MenuError('Failed to load menu: ${e.toString()}'));
    }
  }
  
  Future<void> _onLoadAllMenus(LoadAllMenus event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final menus = await _menuRepository.getAllMenus();
      emit(AllMenusLoaded(menus));
    } catch (e) {
      emit(MenuError('Failed to load menus: ${e.toString()}'));
    }
  }
  
  Future<void> _onCreateMenu(CreateMenu event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final createdMenu = await _menuRepository.createMenu(event.menu);
      emit(MenuLoaded(createdMenu));
      emit(MenuOperationSuccess('Menu created successfully'));
    } catch (e) {
      emit(MenuError('Failed to create menu: ${e.toString()}'));
    }
  }
  
  Future<void> _onUpdateMenu(UpdateMenu event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final updatedMenu = await _menuRepository.updateMenu(event.menu);
      emit(MenuLoaded(updatedMenu));
      emit(MenuOperationSuccess('Menu updated successfully'));
    } catch (e) {
      emit(MenuError('Failed to update menu: ${e.toString()}'));
    }
  }
  
  Future<void> _onDeleteMenu(DeleteMenu event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final success = await _menuRepository.deleteMenu(event.menuId);
      if (success) {
        emit(MenuOperationSuccess('Menu deleted successfully'));
        // Reload all menus after deletion
        add(LoadAllMenus());
      } else {
        emit(MenuError('Failed to delete menu'));
      }
    } catch (e) {
      emit(MenuError('Failed to delete menu: ${e.toString()}'));
    }
  }
  
  Future<void> _onAddCategory(AddCategory event, Emitter<MenuState> emit) async {
    try {
      // Get current menu
      final currentMenu = await _menuRepository.getMenu(event.menuId);
      
      // Add category to menu
      final updatedCategories = List<MenuCategory>.from(currentMenu.categories)..add(event.category);
      final updatedMenu = currentMenu.copyWith(categories: updatedCategories);
      
      // Save updated menu
      final savedMenu = await _menuRepository.updateMenu(updatedMenu);
      emit(MenuLoaded(savedMenu));
      emit(MenuOperationSuccess('Category added successfully'));
    } catch (e) {
      emit(MenuError('Failed to add category: ${e.toString()}'));
    }
  }
  
  Future<void> _onUpdateCategory(UpdateCategory event, Emitter<MenuState> emit) async {
    try {
      // Get current menu
      final currentMenu = await _menuRepository.getMenu(event.menuId);
      
      // Replace category in menu
      final updatedCategories = List<MenuCategory>.from(currentMenu.categories);
      final categoryIndex = updatedCategories.indexWhere((c) => c.id == event.category.id);
      
      if (categoryIndex >= 0) {
        updatedCategories[categoryIndex] = event.category;
        final updatedMenu = currentMenu.copyWith(categories: updatedCategories);
        
        // Save updated menu
        final savedMenu = await _menuRepository.updateMenu(updatedMenu);
        emit(MenuLoaded(savedMenu));
        emit(MenuOperationSuccess('Category updated successfully'));
      } else {
        emit(MenuError('Category not found'));
      }
    } catch (e) {
      emit(MenuError('Failed to update category: ${e.toString()}'));
    }
  }
  
  Future<void> _onDeleteCategory(DeleteCategory event, Emitter<MenuState> emit) async {
    try {
      // Get current menu
      final currentMenu = await _menuRepository.getMenu(event.menuId);
      
      // Remove category from menu
      final updatedCategories = List<MenuCategory>.from(currentMenu.categories)
        ..removeWhere((c) => c.id == event.categoryId);
        
      final updatedMenu = currentMenu.copyWith(categories: updatedCategories);
      
      // Save updated menu
      final savedMenu = await _menuRepository.updateMenu(updatedMenu);
      emit(MenuLoaded(savedMenu));
      emit(MenuOperationSuccess('Category deleted successfully'));
    } catch (e) {
      emit(MenuError('Failed to delete category: ${e.toString()}'));
    }
  }
  
  Future<void> _onAddMenuItem(AddMenuItem event, Emitter<MenuState> emit) async {
    try {
      // Get current menu
      final currentMenu = await _menuRepository.getMenu(event.menuId);
      
      // Find category and add item
      final updatedCategories = List<MenuCategory>.from(currentMenu.categories);
      final categoryIndex = updatedCategories.indexWhere((c) => c.id == event.categoryId);
      
      if (categoryIndex >= 0) {
        final category = updatedCategories[categoryIndex];
        final updatedItems = List<MenuItem>.from(category.items)..add(event.item);
        updatedCategories[categoryIndex] = category.copyWith(items: updatedItems);
        
        final updatedMenu = currentMenu.copyWith(categories: updatedCategories);
        
        // Save updated menu
        final savedMenu = await _menuRepository.updateMenu(updatedMenu);
        emit(MenuLoaded(savedMenu));
        emit(MenuOperationSuccess('Menu item added successfully'));
      } else {
        emit(MenuError('Category not found'));
      }
    } catch (e) {
      emit(MenuError('Failed to add menu item: ${e.toString()}'));
    }
  }
  
  Future<void> _onUpdateMenuItem(UpdateMenuItem event, Emitter<MenuState> emit) async {
    try {
      // Get current menu
      final currentMenu = await _menuRepository.getMenu(event.menuId);
      
      // Find category and update item
      final updatedCategories = List<MenuCategory>.from(currentMenu.categories);
      final categoryIndex = updatedCategories.indexWhere((c) => c.id == event.categoryId);
      
      if (categoryIndex >= 0) {
        final category = updatedCategories[categoryIndex];
        final updatedItems = List<MenuItem>.from(category.items);
        final itemIndex = updatedItems.indexWhere((item) => item.id == event.item.id);
        
        if (itemIndex >= 0) {
          updatedItems[itemIndex] = event.item;
          updatedCategories[categoryIndex] = category.copyWith(items: updatedItems);
          
          final updatedMenu = currentMenu.copyWith(categories: updatedCategories);
          
          // Save updated menu
          final savedMenu = await _menuRepository.updateMenu(updatedMenu);
          emit(MenuLoaded(savedMenu));
          emit(MenuOperationSuccess('Menu item updated successfully'));
        } else {
          emit(MenuError('Menu item not found'));
        }
      } else {
        emit(MenuError('Category not found'));
      }
    } catch (e) {
      emit(MenuError('Failed to update menu item: ${e.toString()}'));
    }
  }
  
  Future<void> _onDeleteMenuItem(DeleteMenuItem event, Emitter<MenuState> emit) async {
    try {
      // Get current menu
      final currentMenu = await _menuRepository.getMenu(event.menuId);
      
      // Find category and delete item
      final updatedCategories = List<MenuCategory>.from(currentMenu.categories);
      final categoryIndex = updatedCategories.indexWhere((c) => c.id == event.categoryId);
      
      if (categoryIndex >= 0) {
        final category = updatedCategories[categoryIndex];
        final updatedItems = List<MenuItem>.from(category.items)
          ..removeWhere((item) => item.id == event.itemId);
          
        updatedCategories[categoryIndex] = category.copyWith(items: updatedItems);
        
        final updatedMenu = currentMenu.copyWith(categories: updatedCategories);
        
        // Save updated menu
        final savedMenu = await _menuRepository.updateMenu(updatedMenu);
        emit(MenuLoaded(savedMenu));
        emit(MenuOperationSuccess('Menu item deleted successfully'));
      } else {
        emit(MenuError('Category not found'));
      }
    } catch (e) {
      emit(MenuError('Failed to delete menu item: ${e.toString()}'));
    }
  }
}