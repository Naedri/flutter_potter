// screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:henri_pottier_flutter/models/book.dart';
import 'package:henri_pottier_flutter/models/cart.dart';

class BookDetailScreen extends StatelessWidget {
  static const routeName = '/book-detail';

  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final book = ModalRoute.of(context)?.settings.arguments as Book;
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
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
                Cart.addItem(book); // Add the book to the cart
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Book added to cart'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
