import 'package:flutter/material.dart';
import 'package:udy_shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({required this.cartItem, Key? key}) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(
              child: Text("${cartItem.price}"),
            ),
          ),
        ),
        title: Text(cartItem.name),
        subtitle: Text("Total: R\$ ${cartItem.price * cartItem.quantity}"),
        trailing: Text("${cartItem.quantity}x"),
      ),
    );
  }
}
