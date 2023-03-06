import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/components/app_drawer.dart';
import 'package:udy_shop/components/order_item.dart';
import 'package:udy_shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: ListView.builder(
          itemCount: orders.items.length,
          itemBuilder: (ctx, i) {
            return OrderItem(order: orders.items[i]);
          }),
    );
  }
}
