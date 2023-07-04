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
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/quotes'));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> quoteData = responseData['quotes'];
        final List<Quote> quotesList = quoteData.map((quoteJson) => Quote.fromJson(quoteJson)).toList();
        return quotesList;
      }
      throw Exception('Failed to fetch quotes');
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
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Quotes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Quote>>(
              future: quotes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final quote = snapshot.data![index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.grey[200],
                        child: ListTile(
                          title: Text(
                            quote.content,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            '- ${quote.author}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





