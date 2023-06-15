import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:henri_pottier_flutter/models/book.dart';
import 'package:henri_pottier_flutter/screens/appbar.dart';
import 'package:henri_pottier_flutter/screens/book_detail_screen.dart';

import '../resources/api_provider.dart';

class HomeScreen extends ConsumerWidget {
  final ApiProvider provider;

  HomeScreen(this.provider, {Key? key}) : super(key: key);

  late final booksProvider = FutureProvider<List<Book>>((ref) async {
    return await provider.fetchBooks();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsyncValue = ref.watch(booksProvider);
    return Scaffold(
      appBar: appBar("Henri potier", provider),
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
                        leading: Image.network(books[index].cover),
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
