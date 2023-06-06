import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:henri_pottier_flutter/models/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Consumer(builder: (context, widgetRef, _) {
        final aCart = widgetRef.watch(cartProvider);
        if (kDebugMode) {
          print(aCart.length);
        }
        return Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: aCart.isNotEmpty
                    ? () {
                        // Clear the cart after successful checkout
                        widgetRef.read(cartProvider.notifier).clearCart();
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
            ),
          ],
        );
      }),
    );
  }
}
