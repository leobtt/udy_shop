import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/models/cart.dart';
import 'package:udy_shop/models/product_list.dart';
import 'package:udy_shop/pages/product_detail_page.dart';
import 'package:udy_shop/pages/product_overview_page.dart';
import 'package:udy_shop/utils/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final theme = ThemeData(fontFamily: 'Lato');

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductList()),
        ChangeNotifierProvider(create: (_) => Cart())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
        ),
        home: ProductOverviewPage(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (_) => const ProductDetailPage(),
        },
      ),
    );
  }
}
