import 'package:flutter/material.dart';

// Book model class
class Book {
  final String title;
  final String author;
  final String image;
  final String description;

  Book({
    required this.title,
    required this.author,
    required this.image,
    required this.description,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Book Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookSearchPage(),
    );
  }
}

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  // List of books (your data source)
  List<Book> allBooks = [
    Book(
        title: 'Flutter for Beginners',
        author: 'John Doe',
        image: 'assets/images/book1.jpg',
        description: 'A beginner’s guide to Flutter.'),
    Book(
        title: 'Advanced Flutter',
        author: 'Jane Doe',
        image: 'assets/images/book2.jpg',
        description: 'Dive deeper into Flutter development.'),
    Book(
        title: 'Dart Programming',
        author: 'James Smith',
        image: 'assets/images/book3.jpg',
        description: 'Master Dart programming language.'),
    Book(
        title: 'Building Apps with Flutter',
        author: 'Emily Clark',
        image: 'assets/images/book4.jpg',
        description: 'Learn how to build apps with Flutter from scratch.'),
  ];

  // Initially, show all books
  List<Book> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    filteredBooks = allBooks;
  }

  // Method to filter books based on search query
  void _filterBooks(String query) {
    setState(() {
      filteredBooks = allBooks
          .where((book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.author.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: BookSearchDelegate(allBooks));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search for a book',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterBooks,
            ),
          ),
          Expanded(
            child: ListView.builder(
              // scrollDirection: Axis.horizontal,
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredBooks[index].title,
                    textAlign: TextAlign.center, // Align text to the center
                  ),

                  subtitle: Text(
                    'by ${filteredBooks[index].author}',
                    textAlign: TextAlign.center, // Align text to the center
                  ),
                  // subtitle: Text('by ${filteredBooks[index].image}'),

                  leading: Container(
                    width: 150,
                    height: 650,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(filteredBooks[index].image),
                        fit: BoxFit
                            .fitWidth, // Make the image fit and cover the container
                      ),
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom SearchDelegate for advanced search UI (optional)
class BookSearchDelegate extends SearchDelegate {
  final List<Book> books;

  BookSearchDelegate(this.books);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books
        .where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].title),
          subtitle: Text('by ${results[index].author}'),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books
        .where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].title),
          subtitle: Text('by ${suggestions[index].author}'),
          onTap: () {
            query = suggestions[index].title;
            showResults(context);
          },
        );
      },
    );
  }
}
