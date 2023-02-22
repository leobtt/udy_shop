import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/components/product_item.dart';
import 'package:udy_shop/models/product.dart';
import 'package:udy_shop/models/product_list.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid(this.showFavorite, {Key? key}) : super(key: key);
  final bool showFavorite;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProduct =
        showFavorite ? provider.favoriteItems : provider.items;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemCount: loadedProduct.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProduct[i],
        child: const ProductItem(),
      ),
    );
  }
}
