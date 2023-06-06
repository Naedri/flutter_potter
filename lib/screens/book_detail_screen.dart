// screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:henri_pottier_flutter/models/book.dart';
import 'package:henri_pottier_flutter/models/provider.dart';
import 'package:henri_pottier_flutter/screens/appbar.dart';

class BookDetailScreen extends ConsumerWidget {
  static const routeName = '/book-detail';

  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ModalRoute.of(context)?.settings.arguments as Book;
    return Scaffold(
      appBar: appBar(book.title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network(book.cover, height: 100, width: 100),
              const SizedBox(height: 10),
              Text('Price: \$${book.price.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              Text(book.synopsis),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).add(book);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Book added to cart'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
