
import 'package:flutter/material.dart';
import 'quote_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote App',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuoteApp(),
    );
  }
}
