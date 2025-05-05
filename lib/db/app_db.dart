import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'table/bookTable.dart';

part 'app_db.g.dart';

@DriftAccessor(tables: [BookTracker])
class BookTrackerDao extends DatabaseAccessor<AppDatabase>
    with _$BookTrackerDaoMixin {
  BookTrackerDao(super.db);

  Stream<List<BookTrackerData>> watchAllBooks() {
    return select(bookTracker).watch();
  }

  Future<List<BookTrackerData>> getAllBooks() => select(bookTracker).get();

  Future insertBook(BookTrackerCompanion book) =>
      into(bookTracker).insert(book);

  Future updateBook(BookTrackerData book) => update(bookTracker).replace(book);

  Future deleteBook(BookTrackerData book) => delete(bookTracker).delete(book);

  Future<void> deleteAllBooks() async {
    await delete(bookTracker).go();
  }

  Future<void> dropTable() async {
    await customStatement('DROP TABLE IF EXISTS book_tracker');
  }

  Future<void> resetDatabase() async {
    await deleteAllBooks();
    await customStatement('DROP TABLE IF EXISTS book_tracker');
  }
}

@DriftDatabase(tables: [BookTracker], daos: [BookTrackerDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase instance = AppDatabase._internal();

  @override
  int get schemaVersion => 1;

  @override
  BookTrackerDao get bookTrackerDao => BookTrackerDao(this);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase(file);
  });
}
