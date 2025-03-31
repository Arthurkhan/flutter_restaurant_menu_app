part of 'menu_bloc.dart';

abstract class MenuState extends Equatable {
  const MenuState();
  
  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final Menu menu;
  
  const MenuLoaded(this.menu);
  
  @override
  List<Object?> get props => [menu];
}

class AllMenusLoaded extends MenuState {
  final List<Menu> menus;
  
  const AllMenusLoaded(this.menus);
  
  @override
  List<Object?> get props => [menus];
}

class MenuOperationSuccess extends MenuState {
  final String message;
  
  const MenuOperationSuccess(this.message);
  
  @override
  List<Object?> get props => [message];
}

class MenuError extends MenuState {
  final String message;
  
  const MenuError(this.message);
  
  @override
  List<Object?> get props => [message];
}