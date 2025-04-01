import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/menu.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../repositories/menu_repository.dart';

/// Service to generate demo menus for first-time users
class DemoDataService {
  final MenuRepository _menuRepository;
  final Random _random = Random();
  final Uuid _uuid = Uuid();
  
  DemoDataService(this._menuRepository);
  
  /// Generate and save a complete demo menu
  Future<Menu> generateDemoMenu() async {
    // Create a demo restaurant menu
    final menu = _createRestaurantMenu();
    
    // Save menu to repository
    await _menuRepository.createMenu(menu);
    
    return menu;
  }
  
  /// Create a restaurant menu with categories and items
  Menu _createRestaurantMenu() {
    final DateTime now = DateTime.now();
    final String menuId = _uuid.v4();
    
    return Menu(
      id: menuId,
      name: 'Sample Restaurant Menu',
      description: 'A delicious sample menu with various categories and items.',
      imageUrl: 'assets/images/restaurant.jpg',
      categories: [
        _createAppetizersCategory(),
        _createMainCoursesCategory(),
        _createDessertCategory(),
        _createBeveragesCategory(),
      ],
      isActive: true,
      createdAt: now,
      updatedAt: now,
      customFields: {
        'restaurantName': 'The Sample Restaurant',
        'location': '123 Main Street',
        'phone': '(555) 123-4567',
        'website': 'www.samplerestaurant.com',
      },
    );
  }
  
  /// Create appetizers category with items
  MenuCategory _createAppetizersCategory() {
    final String categoryId = _uuid.v4();
    final DateTime now = DateTime.now();
    
    return MenuCategory(
      id: categoryId,
      name: 'Appetizers',
      description: 'Start your meal with these delicious appetizers',
      imageUrl: 'assets/images/appetizers.jpg',
      items: [
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Bruschetta',
          description: 'Grilled bread rubbed with garlic and topped with olive oil, salt, tomato, and basil.',
          imageUrl: 'assets/images/bruschetta.jpg',
          price: 8.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Gluten'],
          options: [],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Spinach Artichoke Dip',
          description: 'Creamy dip loaded with spinach and artichokes, served with tortilla chips.',
          imageUrl: 'assets/images/spinach_dip.jpg',
          price: 10.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Dairy'],
          options: [],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Calamari',
          description: 'Crispy fried calamari served with marinara sauce and lemon wedges.',
          imageUrl: 'assets/images/calamari.jpg',
          price: 12.99,
          isVegetarian: false,
          isSpecial: true,
          allergens: ['Shellfish', 'Gluten'],
          options: [],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Wings',
          description: 'Choose from buffalo, BBQ, or teriyaki sauce. Served with celery and blue cheese dressing.',
          imageUrl: 'assets/images/wings.jpg',
          price: 13.99,
          isVegetarian: false,
          isSpecial: false,
          allergens: [],
          options: [
            {'name': 'Sauce', 'choices': ['Buffalo', 'BBQ', 'Teriyaki']},
            {'name': 'Count', 'choices': ['6 pcs', '12 pcs', '18 pcs']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// Create main courses category with items
  MenuCategory _createMainCoursesCategory() {
    final String categoryId = _uuid.v4();
    final DateTime now = DateTime.now();
    
    return MenuCategory(
      id: categoryId,
      name: 'Main Courses',
      description: 'Delicious entrees for every taste',
      imageUrl: 'assets/images/main_courses.jpg',
      items: [
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Grilled Salmon',
          description: 'Fresh Atlantic salmon, grilled and served with seasonal vegetables and lemon butter sauce.',
          imageUrl: 'assets/images/salmon.jpg',
          price: 22.99,
          isVegetarian: false,
          isSpecial: true,
          allergens: ['Fish'],
          options: [
            {'name': 'Cooking Preference', 'choices': ['Medium', 'Well Done']},
            {'name': 'Side', 'choices': ['Mashed Potatoes', 'Rice Pilaf', 'Seasonal Vegetables']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Fettuccine Alfredo',
          description: 'Fettuccine pasta tossed in our homemade creamy Alfredo sauce with parmesan cheese.',
          imageUrl: 'assets/images/fettuccine.jpg',
          price: 16.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Gluten', 'Dairy'],
          options: [
            {'name': 'Add Protein', 'choices': ['Chicken (+$4)', 'Shrimp (+$6)', 'None']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'New York Strip Steak',
          description: '12oz USDA Choice New York Strip steak, grilled to your liking and served with roasted potatoes.',
          imageUrl: 'assets/images/steak.jpg',
          price: 28.99,
          isVegetarian: false,
          isSpecial: false,
          allergens: [],
          options: [
            {'name': 'Cooking Preference', 'choices': ['Rare', 'Medium Rare', 'Medium', 'Medium Well', 'Well Done']},
            {'name': 'Sauce', 'choices': ['Peppercorn', 'Mushroom', 'None']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Vegetable Stir Fry',
          description: 'Fresh seasonal vegetables stir-fried in a savory sauce, served over steamed rice.',
          imageUrl: 'assets/images/stirfry.jpg',
          price: 14.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Soy'],
          options: [
            {'name': 'Spice Level', 'choices': ['Mild', 'Medium', 'Hot']},
            {'name': 'Add Protein', 'choices': ['Tofu (+$3)', 'Chicken (+$4)', 'Beef (+$5)', 'None']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// Create dessert category with items
  MenuCategory _createDessertCategory() {
    final String categoryId = _uuid.v4();
    final DateTime now = DateTime.now();
    
    return MenuCategory(
      id: categoryId,
      name: 'Desserts',
      description: 'Sweet treats to finish your meal',
      imageUrl: 'assets/images/desserts.jpg',
      items: [
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'New York Cheesecake',
          description: 'Classic New York-style cheesecake with a graham cracker crust and your choice of topping.',
          imageUrl: 'assets/images/cheesecake.jpg',
          price: 8.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Dairy', 'Gluten', 'Eggs'],
          options: [
            {'name': 'Topping', 'choices': ['Strawberry', 'Chocolate', 'Caramel', 'Plain']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Chocolate Lava Cake',
          description: 'Warm chocolate cake with a molten chocolate center, served with vanilla ice cream.',
          imageUrl: 'assets/images/lava_cake.jpg',
          price: 9.99,
          isVegetarian: true,
          isSpecial: true,
          allergens: ['Dairy', 'Gluten', 'Eggs'],
          options: [],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Tiramisu',
          description: 'Italian dessert made of ladyfingers dipped in coffee, layered with mascarpone cheese and dusted with cocoa powder.',
          imageUrl: 'assets/images/tiramisu.jpg',
          price: 8.49,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Dairy', 'Gluten', 'Eggs'],
          options: [],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Ice Cream Sundae',
          description: 'Three scoops of ice cream topped with hot fudge, whipped cream, nuts, and a cherry.',
          imageUrl: 'assets/images/sundae.jpg',
          price: 7.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Dairy', 'Nuts'],
          options: [
            {'name': 'Ice Cream Flavors', 'choices': ['Vanilla', 'Chocolate', 'Strawberry', 'Mint Chocolate Chip']},
            {'name': 'Toppings', 'choices': ['Hot Fudge', 'Caramel', 'Strawberry']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// Create beverages category with items
  MenuCategory _createBeveragesCategory() {
    final String categoryId = _uuid.v4();
    final DateTime now = DateTime.now();
    
    return MenuCategory(
      id: categoryId,
      name: 'Beverages',
      description: 'Refreshing drinks to complement your meal',
      imageUrl: 'assets/images/beverages.jpg',
      items: [
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Soft Drinks',
          description: 'Coca-Cola, Diet Coke, Sprite, or Ginger Ale.',
          imageUrl: 'assets/images/soda.jpg',
          price: 2.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: [],
          options: [
            {'name': 'Type', 'choices': ['Coca-Cola', 'Diet Coke', 'Sprite', 'Ginger Ale']},
            {'name': 'Size', 'choices': ['Small', 'Medium', 'Large']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Iced Tea',
          description: 'Freshly brewed unsweetened iced tea.',
          imageUrl: 'assets/images/iced_tea.jpg',
          price: 2.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: [],
          options: [
            {'name': 'Type', 'choices': ['Sweet', 'Unsweetened']},
            {'name': 'Size', 'choices': ['Small', 'Medium', 'Large']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Lemonade',
          description: 'Fresh-squeezed lemonade.',
          imageUrl: 'assets/images/lemonade.jpg',
          price: 3.49,
          isVegetarian: true,
          isSpecial: false,
          allergens: [],
          options: [
            {'name': 'Size', 'choices': ['Small', 'Medium', 'Large']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Coffee',
          description: 'Freshly brewed coffee, regular or decaf.',
          imageUrl: 'assets/images/coffee.jpg',
          price: 2.49,
          isVegetarian: true,
          isSpecial: false,
          allergens: [],
          options: [
            {'name': 'Type', 'choices': ['Regular', 'Decaf']},
            {'name': 'Additions', 'choices': ['Cream', 'Sugar', 'Both', 'None']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// Create a cafe menu with categories and items
  Menu createCafeMenu() {
    final DateTime now = DateTime.now();
    final String menuId = _uuid.v4();
    
    return Menu(
      id: menuId,
      name: 'Sample Cafe Menu',
      description: 'A selection of coffee drinks, pastries, and light meals',
      imageUrl: 'assets/images/cafe.jpg',
      categories: [
        _createCoffeeDrinksCategory(),
        _createPastriesCategory(),
        _createSandwichesCategory(),
      ],
      isActive: true,
      createdAt: now,
      updatedAt: now,
      customFields: {
        'cafeName': 'Sample Cafe',
        'hoursOfOperation': 'Mon-Fri: 7am-7pm, Sat-Sun: 8am-6pm',
        'wifi': 'Available',
      },
    );
  }
  
  /// Create coffee drinks category with items
  MenuCategory _createCoffeeDrinksCategory() {
    final String categoryId = _uuid.v4();
    final DateTime now = DateTime.now();
    
    return MenuCategory(
      id: categoryId,
      name: 'Coffee & Espresso',
      description: 'Our signature coffee and espresso drinks',
      imageUrl: 'assets/images/coffee_drinks.jpg',
      items: [
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Espresso',
          description: 'Single or double shot of our house blend espresso.',
          imageUrl: 'assets/images/espresso.jpg',
          price: 2.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: [],
          options: [
            {'name': 'Size', 'choices': ['Single', 'Double']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Cappuccino',
          description: 'Espresso with steamed milk and foam.',
          imageUrl: 'assets/images/cappuccino.jpg',
          price: 4.49,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Dairy'],
          options: [
            {'name': 'Size', 'choices': ['Small', 'Medium', 'Large']},
            {'name': 'Milk', 'choices': ['Whole', 'Skim', 'Almond', 'Soy']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Latte',
          description: 'Espresso with steamed milk and a light layer of foam.',
          imageUrl: 'assets/images/latte.jpg',
          price: 4.99,
          isVegetarian: true,
          isSpecial: true,
          allergens: ['Dairy'],
          options: [
            {'name': 'Size', 'choices': ['Small', 'Medium', 'Large']},
            {'name': 'Milk', 'choices': ['Whole', 'Skim', 'Almond', 'Soy']},
            {'name': 'Flavor', 'choices': ['Vanilla', 'Caramel', 'Hazelnut', 'None']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// Create pastries category with items
  MenuCategory _createPastriesCategory() {
    // Implementation similar to other categories
    final String categoryId = _uuid.v4();
    final DateTime now = DateTime.now();
    
    return MenuCategory(
      id: categoryId,
      name: 'Pastries',
      description: 'Freshly baked pastries and desserts',
      imageUrl: 'assets/images/pastries.jpg',
      items: [
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Croissant',
          description: 'Buttery, flaky pastry served plain or with butter and jam.',
          imageUrl: 'assets/images/croissant.jpg',
          price: 3.49,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Gluten', 'Dairy'],
          options: [],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Blueberry Muffin',
          description: 'Moist muffin filled with fresh blueberries and topped with sugar.',
          imageUrl: 'assets/images/muffin.jpg',
          price: 3.99,
          isVegetarian: true,
          isSpecial: false,
          allergens: ['Gluten', 'Dairy', 'Eggs'],
          options: [],
          createdAt: now,
          updatedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// Create sandwiches category with items
  MenuCategory _createSandwichesCategory() {
    // Implementation similar to other categories
    final String categoryId = _uuid.v4();
    final DateTime now = DateTime.now();
    
    return MenuCategory(
      id: categoryId,
      name: 'Sandwiches',
      description: 'Delicious sandwiches served all day',
      imageUrl: 'assets/images/sandwiches.jpg',
      items: [
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Turkey & Avocado',
          description: 'Sliced turkey breast with avocado, lettuce, tomato, and mayo on whole grain bread.',
          imageUrl: 'assets/images/turkey_sandwich.jpg',
          price: 9.99,
          isVegetarian: false,
          isSpecial: false,
          allergens: ['Gluten'],
          options: [
            {'name': 'Bread', 'choices': ['Whole Grain', 'White', 'Sourdough']},
            {'name': 'Side', 'choices': ['Chips', 'Side Salad', 'Fruit Cup']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
        MenuItem(
          id: _uuid.v4(),
          categoryId: categoryId,
          name: 'Veggie Wrap',
          description: 'Hummus, mixed greens, cucumber, tomato, and red onion in a spinach tortilla.',
          imageUrl: 'assets/images/veggie_wrap.jpg',
          price: 8.99,
          isVegetarian: true,
          isSpecial: true,
          allergens: ['Gluten'],
          options: [
            {'name': 'Side', 'choices': ['Chips', 'Side Salad', 'Fruit Cup']},
          ],
          createdAt: now,
          updatedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }
}