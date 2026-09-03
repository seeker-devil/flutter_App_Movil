import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/attempts_table.dart';
import 'tables/pending_operations_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AttemptsTable, PendingOperationsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
      : super(
          e ??
              driftDatabase(
                name: 'safeaccess_db',
                web: DriftWebOptions(
                  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                  driftWorker: Uri.parse('drift_worker.dart.js'),
                ),
              ),
        );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations strategy
        },
      );

  // --- Attempts DAOs / Queries ---

  /// Stream of local attempts ordered by createdAtLocal descending
  Stream<List<LocalAttempt>> watchAllAttempts() {
    return (select(attemptsTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAtLocal, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  /// Get all local attempts
  Future<List<LocalAttempt>> getAllAttempts() async {
    return (select(attemptsTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAtLocal, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Insert or update local attempt by clientId
  Future<int> saveAttempt(AttemptsTableCompanion attempt) async {
    return into(attemptsTable).insertOnConflictUpdate(attempt);
  }

  /// Get single attempt by clientId
  Future<LocalAttempt?> getAttemptByClientId(String clientId) async {
    return (select(attemptsTable)..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
  }

  /// Update attempt sync status and server ID
  Future<void> updateAttemptSynced({
    required String clientId,
    required int serverId,
    required DateTime serverUpdatedAt,
  }) async {
    await (update(attemptsTable)..where((t) => t.clientId.equals(clientId))).write(
      AttemptsTableCompanion(
        serverId: Value(serverId),
        serverUpdatedAt: Value(serverUpdatedAt),
        syncStatus: const Value('SYNCED'),
        updatedAtLocal: Value(DateTime.now()),
      ),
    );
  }

  // --- Pending Operations Queue DAOs / Queries ---

  /// Get all active pending operations ordered by id
  Future<List<LocalPendingOperation>> getPendingOperations() async {
    return (select(pendingOperationsTable)
          ..where((t) => t.status.equals('PENDING'))
          ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)]))
        .get();
  }

  /// Enqueue a pending operation
  Future<int> enqueuePendingOperation(PendingOperationsTableCompanion op) async {
    return into(pendingOperationsTable).insertOnConflictUpdate(op);
  }

  /// Update pending operation retry status / backoff / error
  Future<void> updatePendingOperationRetry({
    required String clientId,
    required int retryCount,
    required DateTime nextRetryAt,
    required String lastError,
    required String status,
  }) async {
    await (update(pendingOperationsTable)..where((t) => t.clientId.equals(clientId)))
        .write(
      PendingOperationsTableCompanion(
        retryCount: Value(retryCount),
        nextRetryAt: Value(nextRetryAt),
        lastError: Value(lastError),
        status: Value(status),
      ),
    );
  }

  /// Delete completed or synced pending operation from queue
  Future<void> deletePendingOperation(String clientId) async {
    await (delete(pendingOperationsTable)..where((t) => t.clientId.equals(clientId))).go();
  }

  // --- Full Cleanup on Logout ---

  /// Delete all rows from all tables on logout
  Future<void> clearAllTablesOnLogout() async {
    await transaction(() async {
      await delete(attemptsTable).go();
      await delete(pendingOperationsTable).go();
    });
  }
}
