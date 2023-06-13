import 'package:henri_pottier_flutter/models/book.dart';
import 'package:riverpod/riverpod.dart';

class CartNotifier extends StateNotifier<List<Book>> {
  CartNotifier() : super([]);

  void add(Book book) {
    state = [...state, book];
  }

  void clearCart() {
    state = [];
  }

  void remove(Book book) {
    state = List.from(state)..remove(book);
  }
}

StateNotifierProvider<CartNotifier, List<Book>> cartProvider =
    StateNotifierProvider((_) => CartNotifier());
