import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/models/cart.dart';
import 'package:udy_shop/models/order_list.dart';
import 'package:udy_shop/models/product_list.dart';
import 'package:udy_shop/pages/cart_page.dart';
import 'package:udy_shop/pages/orders_page.dart';
import 'package:udy_shop/pages/product_detail_page.dart';
import 'package:udy_shop/pages/product_form_page.dart';
import 'package:udy_shop/pages/product_overview_page.dart';
import 'package:udy_shop/pages/products_page.dart';
import 'package:udy_shop/utils/app_routes.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => OrderList()),
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
          AppRoutes.HOME: (_) => ProductOverviewPage(),
          AppRoutes.PRODUCT_DETAIL: (_) => const ProductDetailPage(),
          AppRoutes.CART_PAGE: (_) => const CartPage(),
          AppRoutes.ORDERS: (_) => const OrdersPage(),
          AppRoutes.PRODUCTS: (_) => const ProductsPage(),
          AppRoutes.PRODUCT_FORM: (_) => const ProductFormPage(),
        },
      ),
    );
  }
}
