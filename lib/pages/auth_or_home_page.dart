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
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(child: Text('Ocorreu um erro'));
        } else {
          return auth.isAuth ? ProductOverviewPage() : const AuthPage();
        }
      },
    );
  }
}
