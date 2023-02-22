import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:udy_shop/models/cart_item.dart';
import 'package:udy_shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};
  int get itemsCount => _items.length;

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (actual) => CartItem(
                id: actual.id,
                productId: actual.productId,
                name: actual.name,
                quantity: actual.quantity + 1,
                price: actual.price,
              ));
    } else {
      _items.putIfAbsent(product.id, () {
        return CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
        );
      });
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
