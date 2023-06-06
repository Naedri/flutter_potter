import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:henri_pottier_flutter/models/book.dart';
import 'package:henri_pottier_flutter/screens/appbar.dart';
import 'package:henri_pottier_flutter/screens/book_detail_screen.dart';
import 'package:http/http.dart' as http;

final booksProvider = FutureProvider<List<Book>>((ref) async {
  final response =
      await http.get(Uri.parse('https://henri-potier.techx.fr/books'));
  final jsonData = json.decode(response.body);

  List<Book> fetchedBooks = [];
  for (var item in jsonData) {
    var price = item["price"];
    var synopsis = item["synopsis"] as List<dynamic>;
    var cover = item["cover"];
    var title = item["title"];
    fetchedBooks.add(
        Book(title, synopsis.first, cover, double.parse(price.toString())));
  }

  return fetchedBooks;
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsyncValue = ref.watch(booksProvider);
    return Scaffold(
      appBar: appBar("Henri pottier"),
      body: Column(
        children: [
          Builder(builder: (context) {
            return booksAsyncValue.when(
              data: (books) {
                return Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: books.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        leading: Image.network(books[index].cover, scale: 2,),
                        title: Text(books[index].title),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            BookDetailScreen.routeName,
                            arguments: books[index],
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
            );
          }),
        ],
      ),
    );
  }
}
