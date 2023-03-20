import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/models/auth.dart';
import 'package:udy_shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('Bem vindo usuário!'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text("Loja"),
          onTap: () => Navigator.of(context).pushReplacementNamed(
            AppRoutes.AUTH_OR_HOME,
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text("Meus Pedidos"),
          onTap: () => Navigator.of(context).pushReplacementNamed(
            AppRoutes.ORDERS,
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("Gerenciar Produtos"),
          onTap: () => Navigator.of(context).pushReplacementNamed(
            AppRoutes.PRODUCTS,
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Sair"),
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, AppRoutes.AUTH_OR_HOME);
          },
        ),
      ]),
    );
  }
}
