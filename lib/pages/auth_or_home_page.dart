import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/models/auth.dart';
import 'package:udy_shop/pages/auth_page.dart';
import 'package:udy_shop/pages/product_overview_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return auth.isAuth ? ProductOverviewPage() : const AuthPage();
  }
}
