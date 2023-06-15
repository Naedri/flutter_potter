import 'package:http/http.dart' as http;
import '../models/book.dart';
import 'dart:convert';

import '../models/offer.dart';

class ApiProvider {
  http.Client client;

  ApiProvider(this.client);

  fetchBooks() async {
    final response =
        await client.get(Uri.parse('https://henri-potier.techx.fr/books'));
    final jsonData = json.decode(response.body);

    List<Book> fetchedBooks = [];
    for (var item in jsonData) {
      var price = item["price"];
      var synopsis = item["synopsis"] as List<dynamic>;
      var cover = item["cover"];
      var title = item["title"];
      var isbn = item["isbn"];
      fetchedBooks.add(Book(
          title, synopsis.first, cover, double.parse(price.toString()), isbn));
    }

    return fetchedBooks;
  }

  fetchOffers(List<String> isbnList) async {
    /*
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" +
        isbnList.join(",") +
        "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
        */

    final response = await client.get(
      Uri.parse(
          'https://henri-potier.techx.fr/books/${isbnList.join(",")}/commercialOffers'),
    );
    final jsonData = json.decode(response.body);

    List<Offer> fetchedOffers = [];

    for (var item in jsonData["offers"]) {
      var type = item["type"];
      var value = item["value"];
      var sliceValue = item["sliceValue"] ?? 0;
      fetchedOffers.add(Offer(type, value, sliceValue));
    }

    return fetchedOffers;
  }
}
