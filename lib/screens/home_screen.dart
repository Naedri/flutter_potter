// screens/home_screen.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:henri_pottier_flutter/models/book.dart';
import 'package:henri_pottier_flutter/screens/book_detail_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('https://henri-potier.techx.fr/books'));
      final jsonData = json.decode(response.body);

      List<Book> fetchedBooks = [];
      for (var item in jsonData) {
        var price = item["price"];
        var synopsis = item["synopsis"] as List<dynamic>;
        var cover = item["cover"];
        var title = item["title"];
        fetchedBooks.add(Book(title, synopsis.first, cover, double.parse(price.toString())));
      }

      setState(() {
        books = fetchedBooks;
      });
    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching books: $error');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Shopping App'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: Image.network(books[index].cover),
                  title: Text(books[index].title),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      BookDetailScreen.routeName,
                      arguments: books[index],
                    );
                  }
                );
              },
            ),
    );
  }
}
