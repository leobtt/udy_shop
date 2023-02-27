import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/components/app_drawer.dart';
import 'package:udy_shop/components/product_item.dart';
import 'package:udy_shop/models/product_list.dart';
import 'package:udy_shop/utils/app_routes.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (ctx, i) {
            return Column(
              children: [
                ProductItem(
                  product: products.items[i],
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
