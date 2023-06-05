// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:henri_pottier_flutter/models/book.dart';
import 'package:henri_pottier_flutter/screens/book_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Book> books = [
    Book('Book 1', 'Author 1', 'Description 1', 'assets/book1.jpg', 19.99),
    Book('Book 2', 'Author 2', 'Description 2', 'assets/book1.jpg', 14.99),
    // Add more books here
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: Image.asset(books[index].imageUrl),
            title: Text(books[index].title),
            subtitle: Text(books[index].author),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookDetailScreen(books[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
