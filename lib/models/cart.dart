// models/cart.dart
import 'package:henri_pottier_flutter/models/book.dart';

class Cart {
  static final List<Book> _items = [];

  static void addItem(Book book) {
    _items.add(book);
  }

  static void removeItem(Book book) {
    _items.remove(book);
  }

  static List<Book> getCartItems() {
    return _items;
  }

  static double getTotalPrice() {
    double totalPrice = 0;
    for (var book in _items) {
      totalPrice += book.price;
    }
    return totalPrice;
  }

  static bool isItemInCart(Book book) {
    return _items.contains(book);
  }

  static int getCartItemCount() {
    return _items.length;
  }

  static void clearCart() {
    _items.clear();
  }
}
