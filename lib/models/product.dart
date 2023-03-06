import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:udy_shop/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    const baseUrl =
        'https://shop-udemy-ba3a9-default-rtdb.firebaseio.com/products';
    final response = await http.patch(
      Uri.parse('$baseUrl/$id.json'),
      body: jsonEncode({
        "isFavorite": isFavorite,
      }),
    );
    print(" reponse -- ${response.statusCode}");
    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      throw HttpException(
        msg: 'Não foi possível favoritar o produto.',
        statusCode: response.statusCode,
      );
    }
  }
}
