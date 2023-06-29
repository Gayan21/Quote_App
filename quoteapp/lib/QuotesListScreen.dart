import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Quote {
  final String content;
  final String author;

  Quote({required this.content, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      content: json['quote'] as String,
      author: json['author'] as String,
    );
  }
}

class QuotesListScreen extends StatefulWidget {
  @override
  _QuotesListScreenState createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  late Future<List<Quote>> quotes;

  @override
  void initState() {
    super.initState();
    quotes = fetchQuotes();
  }

  Future<List<Quote>> fetchQuotes() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/quotes'));
    if (response.statusCode == 200) {
      final List<dynamic> quoteData = jsonDecode(response.body);
      final List<Quote> quotesList = quoteData.map((quoteJson) => Quote.fromJson(quoteJson)).toList();
      return quotesList;
    } else {
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
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Quotes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<List<Quote>>(
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
    );
  }
}

  

