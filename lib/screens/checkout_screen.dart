import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:henri_pottier_flutter/models/provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aCart = ref.watch(cartProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: aCart.length,
              itemBuilder: (ctx, index) {
                final book = aCart[index];
                return ListTile(
                  leading: Image.network(book.cover),
                  title: Text(book.title),
                  subtitle: Text("${book.price.toString()} \$"),
                );
              },
            ),
          ),
          Text(
              "total: ${aCart.fold(0.0, (previousValue, element) => previousValue + element.price)} \$"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: aCart.isNotEmpty
                  ? () {
                      // Clear the cart after successful checkout
                      ref.read(cartProvider.notifier).clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('successful checkout'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      Navigator.pushNamed(context, '/');
                    }
                  : null,
              child: const Text('Checkout'),
            ),
          )
        ]));
  }
}
