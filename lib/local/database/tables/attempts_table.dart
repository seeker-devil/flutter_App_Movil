import 'package:drift/drift.dart';

@DataClassName('LocalAttempt')
class AttemptsTable extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get clientId => text().unique()();
  IntColumn get serverId => integer().nullable()();
  IntColumn get evaluationId => integer()();
  IntColumn get score => integer().withDefault(const Constant(100))();
  TextColumn get status => text().withDefault(const Constant('APPROVED'))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  DateTimeColumn get createdAtLocal => dateTime()();
  DateTimeColumn get updatedAtLocal => dateTime()();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('SYNCED'))();
}
