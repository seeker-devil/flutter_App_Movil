import 'package:drift/drift.dart';

@DataClassName('LocalEvidence')
class EvidencesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get clientId => text().unique()();
  IntColumn get serverId => integer().nullable()();
  TextColumn get description => text()();
  TextColumn get imagePath => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  DateTimeColumn get capturedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('PENDING'))();
  DateTimeColumn get createdAtLocal => dateTime()();
  DateTimeColumn get updatedAtLocal => dateTime()();
  TextColumn get lastError => text().nullable()();
}
