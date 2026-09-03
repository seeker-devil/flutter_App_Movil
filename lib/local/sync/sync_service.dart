import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../../services/secure_session_storage.dart';
import '../database/app_database.dart';

class SyncService {
  final AppDatabase db;
  final SecureSessionStorage secureStorage;
  final Connectivity connectivity;
  final http.Client httpClient;

  SyncService({
    required this.db,
    required this.secureStorage,
    Connectivity? connectivity,
    http.Client? httpClient,
  })  : connectivity = connectivity ?? Connectivity(),
        httpClient = httpClient ?? http.Client();

  /// Calculate backoff delay in seconds for retryCount (1 -> 2s, 2 -> 4s, 3 -> 8s, 4 -> 16s)
  int calculateBackoffSeconds(int retryCount) {
    return pow(2, retryCount).toInt();
  }

  /// Process all pending operations in queue
  Future<int> processPendingQueue() async {
    final pendingOps = await db.getPendingOperations();
    int syncedCount = 0;

    final token = await secureStorage.readAccessToken();
    if (token == null || token.isEmpty) {
      return 0;
    }

    for (final op in pendingOps) {
      // If nextRetryAt is set and in future, skip for now
      if (op.nextRetryAt != null && DateTime.now().isBefore(op.nextRetryAt!)) {
        continue;
      }

      final success = await _syncSingleOperation(op, token);
      if (success) {
        syncedCount++;
      }
    }

    return syncedCount;
  }

  /// Sync a single pending operation
  Future<bool> _syncSingleOperation(LocalPendingOperation op, String token) async {
    final newRetryCount = op.retryCount + 1;
    const maxRetries = 4;

    try {
      if (op.entityType == 'ATTEMPT' && op.operationType == 'CREATE') {
        final payloadJson = jsonDecode(op.payload) as Map<String, dynamic>;
        
        final response = await httpClient.post(
          Uri.parse('${ApiConfig.baseUrl}/attempts'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'clientId': op.clientId,
            'evaluationId': payloadJson['evaluationId'] ?? 1,
            'score': payloadJson['score'] ?? 100,
            'status': payloadJson['status'] ?? 'APPROVED',
            'startedAt': payloadJson['startedAt'],
            'finishedAt': payloadJson['finishedAt'],
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final resData = jsonDecode(response.body);
          final data = resData['data'];
          final serverId = data['id'] as int;
          final serverUpdatedAtStr = data['updatedAt'] ?? data['createdAt'];
          final serverUpdatedAt = serverUpdatedAtStr != null
              ? DateTime.parse(serverUpdatedAtStr)
              : DateTime.now();

          // Mark local attempt as SYNCED
          await db.updateAttemptSynced(
            clientId: op.clientId,
            serverId: serverId,
            serverUpdatedAt: serverUpdatedAt,
          );

          // Remove from pending queue
          await db.deletePendingOperation(op.clientId);
          return true;
        } else {
          final errorMsg = 'HTTP ${response.statusCode}: ${response.body}';
          await _handleRetry(op, newRetryCount, maxRetries, errorMsg);
          return false;
        }
      }
      return false;
    } catch (e) {
      await _handleRetry(op, newRetryCount, maxRetries, e.toString());
      return false;
    }
  }

  /// Handle failure retry count and backoff
  Future<void> _handleRetry(
    LocalPendingOperation op,
    int newRetryCount,
    int maxRetries,
    String lastError,
  ) async {
    if (newRetryCount >= maxRetries) {
      await db.updatePendingOperationRetry(
        clientId: op.clientId,
        retryCount: newRetryCount,
        nextRetryAt: DateTime.now().add(const Duration(days: 365)),
        lastError: lastError,
        status: 'FAILED',
      );
    } else {
      final delaySecs = calculateBackoffSeconds(newRetryCount);
      final nextRetry = DateTime.now().add(Duration(seconds: delaySecs));

      await db.updatePendingOperationRetry(
        clientId: op.clientId,
        retryCount: newRetryCount,
        nextRetryAt: nextRetry,
        lastError: lastError,
        status: 'PENDING',
      );
    }
  }
}
