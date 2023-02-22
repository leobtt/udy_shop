import 'package:flutter/material.dart';
import 'package:udy_shop/components/product_grid.dart';

class ProductOverviewPage extends StatelessWidget {
  ProductOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
      ),
      body: const Padding(
        padding: const EdgeInsets.all(10.0),
        child: ProductGrid(),
      ),
    );
  }
}
