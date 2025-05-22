import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';

class CartItem {
  final MenuItem item;
  int quantity;
  CartItem({required this.item, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  double get total =>
      _items.fold(0, (sum, ci) => sum + ci.item.price * ci.quantity);

  int getItemQuantity(MenuItem item) {
    final cartItem = _items.firstWhere(
      (ci) => ci.item.id == item.id,
      orElse: () => CartItem(item: item, quantity: 0),
    );
    return cartItem.quantity;
  }

  void addItem(MenuItem item) {
    final index = _items.indexWhere((ci) => ci.item.id == item.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void decreaseQuantity(MenuItem item) {
    final index = _items.indexWhere((ci) => ci.item.id == item.id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(MenuItem item) {
    _items.removeWhere((ci) => ci.item.id == item.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
