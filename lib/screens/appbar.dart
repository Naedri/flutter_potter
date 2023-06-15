import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:henri_pottier_flutter/models/provider.dart';
import 'package:henri_pottier_flutter/resources/api_provider.dart';
import 'package:henri_pottier_flutter/screens/checkout_screen.dart';

class CartCount extends ConsumerWidget {
  final ApiProvider provider;

  const CartCount(this.provider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // use ref to listen to a provider
    final cart = ref.watch(cartProvider);
    final cartItemCount = cart.length;
    var showCartBadge = cartItemCount > 0;
    return badges.Badge(
      badgeContent: Text(cartItemCount.toString()),
      position: badges.BadgePosition.topEnd(top: 0, end: 3),
      badgeAnimation: const badges.BadgeAnimation.scale(),
      showBadge: showCartBadge,
      ignorePointer: false,
      child: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(provider),
              ),
            );
          }),
    );
  }
}

PreferredSizeWidget appBar(String title, ApiProvider provider) {
  return AppBar(
    title: Text(title),
    actions: [CartCount(provider)],
  );
}
