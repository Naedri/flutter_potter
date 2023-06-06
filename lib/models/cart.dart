// models/cart.dart
import 'package:henri_pottier_flutter/models/book.dart';

class Cart {
  final List<Book> _items = [];

  void addItem(Book book) {
    _items.add(book);
  }

  void removeItem(Book book) {
    _items.remove(book);
  }

  List<Book> getCartItems() {
    return _items;
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var book in _items) {
      totalPrice += book.price;
    }
    return totalPrice;
  }

  bool isItemInCart(Book book) {
    return _items.contains(book);
  }

  int getCartItemCount() {
    return _items.length;
  }

  void clearCart() {
    _items.clear();
  }
}
