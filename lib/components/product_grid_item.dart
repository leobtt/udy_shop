import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udy_shop/models/auth.dart';
import 'package:udy_shop/models/cart.dart';
import 'package:udy_shop/models/product.dart';
import 'package:udy_shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(
      context,
      listen: true,
      // não escuta as notificações( false ), ou seja, não renderiza.
      // utilizamos quando estamos usando dados imutáveis.
      // útil para economizar processamento
      // usando o consumer só onde precisará ser notificado
      // é uma pequena otimização que pode não ter relevância dependendo do tamanho do app
    );
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final Auth auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            // child: const Text("texto fixo"), // que pode ser usado no corpo do builder
            builder: (ctx, product, child) => IconButton(
              onPressed: () async {
                try {
                  await product.toggleFavorite(
                      auth.token ?? '', auth.uid ?? '');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produto adicionado com sucesso!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () => cart.removeSingleItem(product.id),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product_preview.jpg'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
