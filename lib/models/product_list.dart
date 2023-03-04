import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:udy_shop/data/dummy_data.dart';
import 'package:udy_shop/models/product.dart';

class ProductList with ChangeNotifier {
  final _baseURL = 'https://shop-udemy-ba3a9-default-rtdb.firebaseio.com';
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  int get itemsCount => _items.length;
  List<Product> get favoriteItems => _items
      .where(
        (element) => element.isFavorite,
      )
      .toList();

  Future<void> addProduct(Product product) async {
    final response = await http.post(Uri.parse('$_baseURL/products.json'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        }));

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> removeProduct(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();

    return Future.value();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final newProduct = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(newProduct);
    } else {
      return addProduct(newProduct);
    }
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
