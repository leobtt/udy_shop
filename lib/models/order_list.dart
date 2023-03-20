import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:udy_shop/models/cart.dart';
import 'package:udy_shop/models/cart_item.dart';
import 'package:udy_shop/models/order.dart';

class OrderList with ChangeNotifier {
  List<Order> _items;
  final String _token;

  OrderList(this._token, this._items);

  List<Order> get items => [..._items];
  int get itemsCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('${dotenv.get("API_URL")}orders.json?auth=$_token'),
      body: jsonEncode(
        {
          "total": cart.totalAmount,
          "date": date.toIso8601String(),
          "products": cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'name': cartItem.name,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
        },
      ),
    );
    _items.insert(
      0,
      Order(
        id: Random().nextDouble.toString(),
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }

  Future<void> loadedOrders() async {
    try {
      List<Order> items = [];

      items.clear();
      final response = await http
          .get(Uri.parse('${dotenv.get('API_URL')}orders.json?auth=$_token'));
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      print("data $data");
      data.forEach(
        (orderId, orderData) {
          items.add(
            Order(
              id: orderId,
              total: orderData['total'],
              date: DateTime.parse(orderData['date']),
              products: (orderData['products'] as List<dynamic>).map((item) {
                return CartItem(
                  id: item['id'],
                  productId: item['productId'],
                  name: item['name'],
                  quantity: item['quantity'],
                  price: item['price'],
                );
              }).toList(),
            ),
          );
        },
      );

      _items = items.reversed.toList();
      notifyListeners();
    } catch (e) {
      print('errpr $e');
    }
  }
}
