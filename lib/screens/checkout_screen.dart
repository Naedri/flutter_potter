import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:henri_pottier_flutter/models/book.dart';
import 'package:henri_pottier_flutter/models/provider.dart';
import 'package:http/http.dart' as http;

part 'checkout_screen.freezed.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  CheckoutViewState createState() => CheckoutViewState();
}

@freezed
abstract class MyParameter with _$MyParameter {
  factory MyParameter({
    required List<String> isbnList,
    required double totalPrice,
  }) = _MyParameter;
}

final commercialOfferProvider =
    FutureProvider.family<double, MyParameter>((ref, myParameter) async {
  final response = await http.get(
    Uri.parse(
        'https://henri-potier.techx.fr/books/${myParameter.isbnList.join(",")}/commercialOffers'),
  );
  final jsonData = json.decode(response.body);

  List<dynamic> offers = jsonData['offers'];
  double totalPrice = myParameter.totalPrice;
  double bestPrice = totalPrice;
  String bestType = "";
  for (var offer in offers) {
    if (offer['type'] == 'percentage') {
      double percentage = offer['value'] / 100;
      double discount = totalPrice * percentage;
      double priceAfterDiscount = totalPrice - discount;
      if (priceAfterDiscount < bestPrice) {
        bestPrice = priceAfterDiscount;
        bestType = offer['type'];
      }
    } else if (offer['type'] == 'minus') {
      int value = offer['value'];
      double priceAfterDiscount = totalPrice - value;
      if (priceAfterDiscount < bestPrice) {
        bestPrice = priceAfterDiscount;
        bestType = offer['type'];
      }
    } else if (offer['type'] == 'slice') {
      int sliceValue = offer['sliceValue'];
      int value = offer['value'];
      int sliceDiscount = (totalPrice ~/ sliceValue) * value;
      double priceAfterDiscount = totalPrice - sliceDiscount;
      if (priceAfterDiscount < bestPrice) {
        bestPrice = priceAfterDiscount;
        bestType = offer['type'];
      }
    }
  }
  if (kDebugMode) {
    print("best offer type is $bestType");
  }
  return bestPrice;
});

class CheckoutViewState extends ConsumerState<CheckoutScreen> {
  bool _isCheckingOut = false;

  @override
  void initState() {
    super.initState();
    ref.read(cartProvider);
  }

  @override
  Widget build(BuildContext context) {
    final aCart = ref.watch(cartProvider);

    final mapCount = <Book, int>{};
    for (var book in aCart) {
      if (mapCount.containsKey(book)) {
        mapCount[book] = (mapCount[book]! + 1);
      } else {
        mapCount[book] = 1;
      }
    }
    var bookStacked = mapCount.keys.toList();
    List<String> isbnList = bookStacked.map((book) => book.isbn).toList();
    double totalPrice = aCart.fold(
        0.0, (previousValue, element) => previousValue + element.price);
    final commercialOffers = ref.watch(
      commercialOfferProvider(
          MyParameter(isbnList: isbnList, totalPrice: totalPrice)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bookStacked.length,
              itemBuilder: (ctx, index) {
                final book = bookStacked[index];
                return ListTile(
                  leading: Image.network(book.cover),
                  title: Text(
                    "${book.title} ${mapCount[book]! > 1 ? " (${mapCount[book]})" : ""}",
                  ),
                  subtitle: Text(
                    "${(book.price * mapCount[book]!).toStringAsFixed(2)} \$",
                  ),
                );
              },
            ),
          ),
          Builder(builder: (context) {
            return commercialOffers.when(
                data: (price) => Text(
                      "total: ${price.toStringAsFixed(2)} \$ (discount: -${(totalPrice - price).toStringAsFixed(2)} \$)",
                    ),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                error: (error, stackTrace) => Center(
                      child: Text('Error: $error'),
                    ));
          }),
          _isCheckingOut
              ? const CircularProgressIndicator()
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: aCart.isNotEmpty && !_isCheckingOut && commercialOffers.hasValue
                  ? () {
                      // Start the checkout animation
                      setState(() {
                        _isCheckingOut = true;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        // Stop the checkout animation after a delay (simulate a real purchase)
                        setState(() {
                          _isCheckingOut = false;
                        });
                        ref.read(cartProvider.notifier).clearCart();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successful checkout'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/');
                      });
                    }
                  : null,
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
