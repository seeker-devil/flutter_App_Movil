import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_quiz_app/local/database/app_database.dart';
import 'package:training_quiz_app/services/evidence_service.dart';

void main() {
  late AppDatabase db;
  late EvidenceService evidenceService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    evidenceService = EvidenceService(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Week 14 Native Features & Evidence Storage Tests', () {
    test('1. Save local safety evidence with text and optional GPS coordinates', () async {
      final evidence = await evidenceService.createLocalEvidence(
        description: 'Casco de protección rajado en área de calderas.',
        latitude: -0.180653,
        longitude: -78.467838,
      );

      expect(evidence.id, greaterThan(0));
      expect(evidence.description, equals('Casco de protección rajado en área de calderas.'));
      expect(evidence.latitude, equals(-0.180653));
      expect(evidence.longitude, equals(-78.467838));
      expect(evidence.syncStatus, equals('PENDING'));
      expect(evidence.clientId, isNotEmpty);

      // Verify pending operation queue entry
      final pendingOps = await db.getPendingOperations();
      expect(pendingOps.length, equals(1));
      expect(pendingOps.first.entityType, equals('EVIDENCE'));
      expect(pendingOps.first.clientId, equals(evidence.clientId));
    });

    test('2. Save local evidence without optional camera/GPS (text only)', () async {
      final evidence = await evidenceService.createLocalEvidence(
        description: 'Falta señalización de extintor en pasillo B.',
      );

      expect(evidence.id, greaterThan(0));
      expect(evidence.imagePath, isNull);
      expect(evidence.latitude, isNull);
      expect(evidence.longitude, isNull);
      expect(evidence.syncStatus, equals('PENDING'));
    });

    test('3. Update evidence sync status after successful backend response', () async {
      final evidence = await evidenceService.createLocalEvidence(
        description: 'Observación de prueba de sincronización',
      );

      await db.updateEvidenceSynced(
        clientId: evidence.clientId,
        serverId: 402,
      );

      final updated = await db.getEvidenceByClientId(evidence.clientId);
      expect(updated?.syncStatus, equals('SYNCED'));
      expect(updated?.serverId, equals(402));
    });

    test('4. Clear all evidence rows and queue on logout', () async {
      await evidenceService.createLocalEvidence(
        description: 'Evidencia antes de logout',
      );

      var evidences = await db.getAllEvidences();
      expect(evidences.length, equals(1));

      await db.clearAllTablesOnLogout();

      evidences = await db.getAllEvidences();
      expect(evidences, isEmpty);

      final ops = await db.getPendingOperations();
      expect(ops, isEmpty);
    });
  });
}
