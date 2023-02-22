import 'package:flutter/cupertino.dart';
import 'package:udy_shop/data/dummy_data.dart';
import 'package:udy_shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items
      .where(
        (element) => element.isFavorite,
      )
      .toList();

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  // bool _showFavoriteOnly = false;

  // List<Product> get items {
  //   if (_showFavoriteOnly) {
  //     return _items.where((element) => element.isFavorite).toList();
  //   }
  //   return [..._items];
  // }

  // void showFavorite() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }
}
