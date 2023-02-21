import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/components/product_item.dart';
import 'package:udy_shop/data/dummy_data.dart';
import 'package:udy_shop/models/product.dart';
import 'package:udy_shop/models/product_list.dart';

class ProductOverviewPage extends StatelessWidget {
  ProductOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProduct = provider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemCount: loadedProduct.length,
          itemBuilder: (ctx, i) => ProductItem(
            product: loadedProduct[i],
          ),
        ),
      ),
    );
  }
}
