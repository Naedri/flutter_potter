// main.dart
import 'package:flutter/material.dart';
import 'package:henri_pottier_flutter/screens/book_detail_screen.dart';
import 'package:henri_pottier_flutter/screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => HomeScreen(),
        BookDetailScreen.routeName: (ctx) => const BookDetailScreen(),
      },    );
  }
}
