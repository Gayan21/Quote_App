import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';

import 'package:quoteapp/quote_app.dart' as app;
import 'package:quoteapp/QuotesListScreen.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late Future<List<app.Quote>> quotes;

  @override
  void initState() {
    super.initState();
    quotes = fetchQuotes();
  }

  Future<List<app.Quote>> fetchQuotes() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/quotes/random'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final quotesJson = json['contents']['quotes'] as List<dynamic>;
      final quotesList = quotesJson
          .map((quoteJson) => app.Quote(
                content: quoteJson['quote'],
                author: quoteJson['author'],
              ))
          .toList();
      return quotesList;
    } else {
      throw Exception('Failed to fetch quotes');
    }
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Quotes'),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Quote of the Day',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: FutureBuilder<List<app.Quote>>(
              future: quotes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final quote = snapshot.data![index];
                      return ListTile(
                        title: Text(quote.content),
                        subtitle: Text('- ${quote.author}'),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_quote),
          label: 'Quotes',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          // Handle home navigation
          // ...
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuotesListScreen(),
            ),
          );
        }
      },
    ),
  );
}

}
