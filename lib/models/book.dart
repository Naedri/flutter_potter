// models/book.dart
class Book {
  final String title;
  final String synopsis;
  final String cover;
  final double price;
  final String isbn;

  Book(this.title, this.synopsis, this.cover, this.price, this.isbn);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && title == other.title;

  @override
  int get hashCode => title.hashCode;
}
