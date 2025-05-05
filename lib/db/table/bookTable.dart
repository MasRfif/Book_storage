import 'package:drift/drift.dart';

class BookTracker extends Table {
  @override
  String get tableName => 'book_tracker';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get author => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().named('description')();
  BoolColumn get isFavorite => boolean().withDefault(Constant(false))();
  BoolColumn get isRead => boolean().withDefault(Constant(false))();
  TextColumn get imageUrl => text().withLength(min: 1, max: 255)();
}
