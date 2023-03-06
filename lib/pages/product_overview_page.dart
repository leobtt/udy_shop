import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/components/app_drawer.dart';
import 'package:udy_shop/components/badge.dart';
import 'package:udy_shop/components/product_grid.dart';
import 'package:udy_shop/models/cart.dart';
import 'package:udy_shop/models/product_list.dart';
import 'package:udy_shop/utils/app_routes.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductOverviewPage extends StatefulWidget {
  ProductOverviewPage({super.key});

  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(
      context,
      listen: false,
    ).loadedProducts().then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final ProductList provider = Provider.of<ProductList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text("Somente Favoritos"),
              ),
              PopupMenuItem(
                value: FilterOptions.all,
                child: Text("Todos"),
              )
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART_PAGE);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ProductGrid(_showFavoriteOnly),
      ),
      drawer: const AppDrawer(),
    );
  }
}
