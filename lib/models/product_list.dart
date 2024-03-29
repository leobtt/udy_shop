import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:udy_shop/exceptions/http_exception.dart';
import 'package:udy_shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = [];
  String _token;
  String _uid;

  ProductList([
    this._token = '',
    this._uid = '',
    this._items = const [],
  ]);
  // passo os items nos segundo para não perder os items que já foram carregados quando atualizar o provider

  final _baseUrl = '${dotenv.get("API_URL")}products';
  final _baseUrlFav = '${dotenv.get("API_URL")}userFavorites';

  List<Product> get items => [..._items];
  int get itemsCount => _items.length;
  List<Product> get favoriteItems => _items
      .where(
        (element) => element.isFavorite,
      )
      .toList();

  Future<void> loadedProducts() async {
    try {
      _items.clear();
      final response = await http.get(Uri.parse('$_baseUrl.json?auth=$_token'));
      if (response.body == 'null') return;
      final favResponse =
          await http.get(Uri.parse('$_baseUrlFav/$_uid.json?auth=$_token'));
      Map<String, dynamic> favData =
          favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((productId, productData) {
        final isFavorite = favData[productId] ?? false;
        _items.add(
          Product(
            id: productId,
            name: productData['name'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: isFavorite,
          ),
        );
      });
      notifyListeners();
    } catch (e) {
      print('errpr $e');
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(Uri.parse('$_baseUrl.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }));

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      final response = await http.patch(
        Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl
          },
        ),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
            msg: 'Não foi possível excluir o produto.',
            statusCode: response.statusCode);
      }
    }
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
