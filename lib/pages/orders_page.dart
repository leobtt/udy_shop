import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/components/app_drawer.dart';
import 'package:udy_shop/components/order_item.dart';
import 'package:udy_shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: FutureBuilder(
          future: Provider.of<OrderList>(context, listen: false).loadedOrders(),
          builder: ((ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              return const Center(child: Text('Ocorreu um erro!'));
            } else {
              return Consumer<OrderList>(
                builder: (context, orders, child) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderItem(order: orders.items[i]),
                ),
              );
            }
          })),
    );
  }
}
