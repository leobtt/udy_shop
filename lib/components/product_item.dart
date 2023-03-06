import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/exceptions/http_exception.dart';
import 'package:udy_shop/models/product.dart';
import 'package:udy_shop/models/product_list.dart';
import 'package:udy_shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
              },
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Tem certeza?'),
                          content:
                              const Text('Deseja remover o produto da loja?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Não'),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await Provider.of<ProductList>(
                                    context,
                                    listen: false,
                                  ).removeProduct(product);
                                } on HttpException catch (error) {
                                  msg.showSnackBar(
                                    SnackBar(
                                      content: Text(error.toString()),
                                    ),
                                  );
                                } finally {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Sim'),
                            ),
                          ],
                        ));
              },
              color: Theme.of(context).colorScheme.error,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
