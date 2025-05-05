import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:book_tracker_v9/db/app_db.dart';
import 'package:book_tracker_v9/pages/book/book_detail_page.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late AppDatabase _db;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase.instance;
  }

  Future<List<BookTrackerData>> _fetchBooksFromJson() async {
    final String response = await rootBundle.loadString('assets/books.json');
    final List<dynamic> data = json.decode(response);
    return data.map((book) => BookTrackerData.fromJson(book)).toList();
  }

  Future<List<BookTrackerData>> _mergeBooks(
    List<BookTrackerData> databaseBooks,
  ) async {
    final jsonBooks = await _fetchBooksFromJson();
    return [...jsonBooks, ...databaseBooks];
  }

  Future<void> _deleteBook(int id) async {
    await _db.bookTrackerDao.deleteBook(
      BookTrackerData(
        id: id,
        title: '',
        author: '',
        description: '',
        imageUrl: '',
        isFavorite: false,
        isRead: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: Center(
          child: Text(
            "Book Heaven",

            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: textColor,
            ),
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: StreamBuilder<List<BookTrackerData>>(
        stream: _db.bookTrackerDao.watchAllBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No books added yet',
                style: TextStyle(color: Colors.brown[900], fontSize: 18),
              ),
            );
          } else {
            return FutureBuilder<List<BookTrackerData>>(
              future: _mergeBooks(snapshot.data!),
              builder: (context, finalSnapshot) {
                if (!finalSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final books = finalSnapshot.data!;
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading:
                              book.imageUrl.startsWith('http')
                                  ? Image.network(
                                    book.imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                  : File(book.imageUrl).existsSync()
                                  ? Image.file(
                                    File(book.imageUrl),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(Icons.image_not_supported),
                          title: Text(book.title),
                          subtitle: Text(book.author),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: const Text(
                                      'Are you sure you want to delete this book?',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _deleteBook(book.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookDetailPage(book: book),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
