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

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (actual) => CartItem(
          id: actual.id,
          productId: actual.productId,
          name: actual.name,
          quantity: actual.quantity - 1,
          price: actual.price,
        ),
      );
    }
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
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
