import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:henri_pottier_flutter/resources/api_provider.dart';
import 'package:henri_pottier_flutter/screens/book_detail_screen.dart';
import 'package:http/http.dart' as http;

import 'screens/home_screen.dart';

void main() {
  runApp(MyApp(ApiProvider(http.Client())));
}

class MyApp extends StatelessWidget {
  final ApiProvider provider;

  const MyApp(this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Book Shopping App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(provider),
          BookDetailScreen.routeName: (context) => BookDetailScreen(provider),
        },
      ),
    );
  }
}
