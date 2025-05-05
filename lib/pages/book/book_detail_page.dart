import 'package:flutter/material.dart';
import 'package:book_tracker_v9/db/app_db.dart';

class BookDetailPage extends StatefulWidget {
  final BookTrackerData book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late bool isFavorite;
  late bool isRead;
  final db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.book.isFavorite;
    isRead = widget.book.isRead;
  }

  Future<void> _toggleFavorite() async {
    setState(() => isFavorite = !isFavorite);
    await db.bookTrackerDao.updateBook(
      widget.book.copyWith(isFavorite: isFavorite),
    );
  }

  Future<void> _toggleRead() async {
    setState(() => isRead = !isRead);
    await db.bookTrackerDao.updateBook(widget.book.copyWith(isRead: isRead));
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Image.network(
                book.imageUrl,
                height: 300,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('By ${book.author}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text(book.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _toggleRead,
                  icon: Icon(
                    isRead ? Icons.check_circle : Icons.check_circle_outline,
                    color: isRead ? Colors.green : Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
