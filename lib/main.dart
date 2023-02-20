import 'package:flutter/material.dart';
import 'package:udy_shop/pages/product_overview_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final theme = ThemeData(fontFamily: 'Lato');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.deepOrange,
        ),
      ),
      home: ProductOverviewPage(),
    );
  }
}
