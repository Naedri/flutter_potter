import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:henri_pottier_flutter/models/book.dart';
import 'package:henri_pottier_flutter/models/provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  CheckoutViewState createState() => CheckoutViewState();
}

class CheckoutViewState extends ConsumerState<CheckoutScreen> {
  bool _isCheckingOut = false;

  @override
  void initState() {
    super.initState();
    ref.read(cartProvider);
  }

  @override
  Widget build(BuildContext context) {
    final aCart = ref.watch(cartProvider);
    final mapCount = <Book, int>{};
    for (var book in aCart) {
      if (mapCount.containsKey(book)) {
        mapCount[book] = (mapCount[book]! + 1);
      } else {
        mapCount[book] = 1;
      }
    }
    var bookStacked = mapCount.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bookStacked.length,
              itemBuilder: (ctx, index) {
                final book = bookStacked[index];
                return ListTile(
                  leading: Image.network(book.cover),
                  title: Text(
                    "${book.title} ${mapCount[book]! > 1 ? " (${mapCount[book]})" : ""}",
                  ),
                  subtitle: Text(
                    "${(book.price * mapCount[book]!).toStringAsFixed(2)} \$",
                  ),
                );
              },
            ),
          ),
          Text(
            "total: ${aCart.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)} \$",
          ),
          _isCheckingOut
              ? const CircularProgressIndicator()
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: aCart.isNotEmpty && !_isCheckingOut
                  ? () {
                      // Start the checkout animation
                      setState(() {
                        _isCheckingOut = true;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        // Stop the checkout animation after a delay (simulate a real purchase)
                        setState(() {
                          _isCheckingOut = false;
                        });
                        ref.read(cartProvider.notifier).clearCart();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successful checkout'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/');
                      });
                    }
                  : null,
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
