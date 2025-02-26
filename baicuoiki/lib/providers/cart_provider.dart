import 'package:flutter/foundation.dart';
import 'package:baicuoiki/product/Product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get itemCount {
    return _items.length;
  }

  // Getter for selected items' total amount
  double get selectedItemsTotal {
    return _items
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Getter for the count of selected items
  int get selectedItemsCount {
    return _items.where((item) => item.isSelected).length;
  }

  void addItem(Product product) {
    final existingIndex = _items.indexWhere((item) => item.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(
        id: product.id,
        title: product.title ?? '',
        price: product.price ?? 0.0,
        quantity: 1,
        image: product.image ?? '',
        isSelected: false, // Default isSelected as false
      ));
    }
    notifyListeners();
  }

  void removeItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(int id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items = [];
    notifyListeners();
  }

  // Toggle item selection state
  void toggleItemSelection(int id, bool isSelected) {
    final item = _items.firstWhere((item) => item.id == id);
    item.isSelected = isSelected;
    notifyListeners();
  }

  void clearPurchasedItems() {
    _items.removeWhere((item) => item.isSelected); // Assuming isSelected marks purchased items
  }
}

class CartItem {
  final int id;
  final String title;
  final double price;
  int quantity;
  final String image;
  bool isSelected; // Add the isSelected property

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.image,
    this.isSelected = false, // Default value for isSelected
  });
}
