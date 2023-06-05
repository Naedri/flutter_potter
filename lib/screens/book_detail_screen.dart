// screens/book_detail_screen.dart
import 'package:flutter/material.dart';

import 'package:henri_pottier_flutter/models/book.dart';
import 'package:henri_pottier_flutter/models/cart.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(book.imageUrl, height: 100, width: 100),
            const SizedBox(height: 10),
            Text('Author: ${book.author}'),
            const SizedBox(height: 10),
            Text('Price: \$${book.price.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            Text(book.description),
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
