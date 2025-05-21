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

  double get totalPrice =>
      _items.fold(0, (sum, ci) => sum + ci.item.price * ci.quantity);

  void addItem(MenuItem item) {
    final index = _items.indexWhere((ci) => ci.item.id == item.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((ci) => ci.item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int qty) {
    final index = _items.indexWhere((ci) => ci.item.id == itemId);
    if (index >= 0 && qty > 0) {
      _items[index].quantity = qty;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
