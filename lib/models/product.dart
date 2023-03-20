import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  Future<void> toggleFavorite(String token, String uid) async {
    isFavorite = !isFavorite;

    final baseUrl = '${dotenv.get("API_URL")}userFavorites';
    final response = await http.put(
      Uri.parse('$baseUrl/$uid/$id.json?auth=$token'),
      body: jsonEncode(isFavorite),
    );

    if (response.statusCode >= 400) {
      isFavorite = false;
      throw HttpException(
        msg: 'Não foi possível favoritar o produto.',
        statusCode: response.statusCode,
      );
    }
    notifyListeners();
  }
}
