import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';

import 'package:quoteapp/SecondScreen.dart';

// Rest of the code remains the same



class Quote {
  final String content;
  final String author;

  Quote({required this.content, required this.author});
}


class QuoteApp extends StatefulWidget {
  @override
  _QuoteAppState createState() => _QuoteAppState();
}

class _QuoteAppState extends State<QuoteApp> {
  late Future<Quote> quote;

  @override
  void initState() {
    super.initState();
    // quote = fetchQuote();
  }

  // Future<Quote> fetchQuote() async {
  //   final response =
  //       await http.get(Uri.parse('http://quotes.rest/qod.json'));
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     final quoteContent = json['contents']['quotes'][0]['quote'];
  //     final quoteAuthor = json['contents']['quotes'][0]['author'];
  //     return Quote(content: quoteContent, author: quoteAuthor);
  //   } else {
  //     throw Exception('Failed to fetch quote');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
  appBar: AppBar(
    title: Text('Quote App'),
  ),
  body: Center(
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondScreen()),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/images/quote.png',
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            'Quotes',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  ),
);


  }
}
