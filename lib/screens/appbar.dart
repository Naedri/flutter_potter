import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:henri_pottier_flutter/models/provider.dart';
import 'package:henri_pottier_flutter/screens/checkout_screen.dart';

PreferredSizeWidget appBar(String title) {
  return AppBar(
    title: Text(title),
    actions: [
      Consumer(
        builder: (context, widgetRef, _) {
          final aCart = widgetRef.watch(cartProvider);
          final cartItemCount = aCart.length;
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutScreen(),
                    ),
                  );
                }),
          );
        },
      ),
    ],
  );
}
