import 'package:drift/drift.dart';

@DataClassName('LocalPendingOperation')
class PendingOperationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get clientId => text().unique()();
  TextColumn get entityType => text()();
  TextColumn get operationType => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
}
