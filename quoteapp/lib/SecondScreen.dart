import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/quotes/random'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final quote = app.Quote(
          content: json['quote'] as String,
          author: json['author'] as String,
        );
        return [quote];
      } else {
        throw Exception('Failed to fetch quotes. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch quotes');
    }
  }

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
                    final quote = snapshot.data![0];
                    return ListTile(
                      title: Text(quote.content),
                      subtitle: Text('- ${quote.author}'),
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


