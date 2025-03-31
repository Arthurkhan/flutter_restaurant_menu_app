part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadMenu extends MenuEvent {
  final String menuId;
  
  const LoadMenu(this.menuId);
  
  @override
  List<Object?> get props => [menuId];
}

class LoadAllMenus extends MenuEvent {}

class CreateMenu extends MenuEvent {
  final Menu menu;
  
  const CreateMenu(this.menu);
  
  @override
  List<Object?> get props => [menu];
}

class UpdateMenu extends MenuEvent {
  final Menu menu;
  
  const UpdateMenu(this.menu);
  
  @override
  List<Object?> get props => [menu];
}

class DeleteMenu extends MenuEvent {
  final String menuId;
  
  const DeleteMenu(this.menuId);
  
  @override
  List<Object?> get props => [menuId];
}

class AddCategory extends MenuEvent {
  final String menuId;
  final MenuCategory category;
  
  const AddCategory({
    required this.menuId,
    required this.category,
  });
  
  @override
  List<Object?> get props => [menuId, category];
}

class UpdateCategory extends MenuEvent {
  final String menuId;
  final MenuCategory category;
  
  const UpdateCategory({
    required this.menuId,
    required this.category,
  });
  
  @override
  List<Object?> get props => [menuId, category];
}

class DeleteCategory extends MenuEvent {
  final String menuId;
  final String categoryId;
  
  const DeleteCategory({
    required this.menuId,
    required this.categoryId,
  });
  
  @override
  List<Object?> get props => [menuId, categoryId];
}

class AddMenuItem extends MenuEvent {
  final String menuId;
  final String categoryId;
  final MenuItem item;
  
  const AddMenuItem({
    required this.menuId,
    required this.categoryId,
    required this.item,
  });
  
  @override
  List<Object?> get props => [menuId, categoryId, item];
}

class UpdateMenuItem extends MenuEvent {
  final String menuId;
  final String categoryId;
  final MenuItem item;
  
  const UpdateMenuItem({
    required this.menuId,
    required this.categoryId,
    required this.item,
  });
  
  @override
  List<Object?> get props => [menuId, categoryId, item];
}

class DeleteMenuItem extends MenuEvent {
  final String menuId;
  final String categoryId;
  final String itemId;
  
  const DeleteMenuItem({
    required this.menuId,
    required this.categoryId,
    required this.itemId,
  });
  
  @override
  List<Object?> get props => [menuId, categoryId, itemId];
}