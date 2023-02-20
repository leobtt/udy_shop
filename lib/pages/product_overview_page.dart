import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:udy_shop/components/product_item.dart';
import 'package:udy_shop/data/dummy_data.dart';
import 'package:udy_shop/models/product.dart';

class ProductOverviewPage extends StatelessWidget {
  ProductOverviewPage({super.key});

  final List<Product> loadedProduct = dummyProducts;

  @override
  Widget build(BuildContext context) {
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
