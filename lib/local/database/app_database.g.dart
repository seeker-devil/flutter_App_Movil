// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AttemptsTableTable extends AttemptsTable
    with TableInfo<$AttemptsTableTable, LocalAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
      'local_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _evaluationIdMeta =
      const VerificationMeta('evaluationId');
  @override
  late final GeneratedColumn<int> evaluationId = GeneratedColumn<int>(
      'evaluation_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(100));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('APPROVED'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _finishedAtMeta =
      const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
      'finished_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtLocalMeta =
      const VerificationMeta('createdAtLocal');
  @override
  late final GeneratedColumn<DateTime> createdAtLocal =
      GeneratedColumn<DateTime>('created_at_local', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtLocalMeta =
      const VerificationMeta('updatedAtLocal');
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>('updated_at_local', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SYNCED'));
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        clientId,
        serverId,
        evaluationId,
        score,
        status,
        startedAt,
        finishedAt,
        createdAtLocal,
        updatedAtLocal,
        serverUpdatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempts_table';
  @override
  VerificationContext validateIntegrity(Insertable<LocalAttempt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('evaluation_id')) {
      context.handle(
          _evaluationIdMeta,
          evaluationId.isAcceptableOrUnknown(
              data['evaluation_id']!, _evaluationIdMeta));
    } else if (isInserting) {
      context.missing(_evaluationIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
          _finishedAtMeta,
          finishedAt.isAcceptableOrUnknown(
              data['finished_at']!, _finishedAtMeta));
    }
    if (data.containsKey('created_at_local')) {
      context.handle(
          _createdAtLocalMeta,
          createdAtLocal.isAcceptableOrUnknown(
              data['created_at_local']!, _createdAtLocalMeta));
    } else if (isInserting) {
      context.missing(_createdAtLocalMeta);
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
          _updatedAtLocalMeta,
          updatedAtLocal.isAcceptableOrUnknown(
              data['updated_at_local']!, _updatedAtLocalMeta));
    } else if (isInserting) {
      context.missing(_updatedAtLocalMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAttempt(
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_id'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
      evaluationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}evaluation_id'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      finishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}finished_at']),
      createdAtLocal: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at_local'])!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}updated_at_local'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $AttemptsTableTable createAlias(String alias) {
    return $AttemptsTableTable(attachedDatabase, alias);
  }
}

class LocalAttempt extends DataClass implements Insertable<LocalAttempt> {
  final int localId;
  final String clientId;
  final int? serverId;
  final int evaluationId;
  final int score;
  final String status;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final DateTime createdAtLocal;
  final DateTime updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String syncStatus;
  const LocalAttempt(
      {required this.localId,
      required this.clientId,
      this.serverId,
      required this.evaluationId,
      required this.score,
      required this.status,
      required this.startedAt,
      this.finishedAt,
      required this.createdAtLocal,
      required this.updatedAtLocal,
      this.serverUpdatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['evaluation_id'] = Variable<int>(evaluationId);
    map['score'] = Variable<int>(score);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['created_at_local'] = Variable<DateTime>(createdAtLocal);
    map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  AttemptsTableCompanion toCompanion(bool nullToAbsent) {
    return AttemptsTableCompanion(
      localId: Value(localId),
      clientId: Value(clientId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      evaluationId: Value(evaluationId),
      score: Value(score),
      status: Value(status),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      createdAtLocal: Value(createdAtLocal),
      updatedAtLocal: Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory LocalAttempt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAttempt(
      localId: serializer.fromJson<int>(json['localId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      evaluationId: serializer.fromJson<int>(json['evaluationId']),
      score: serializer.fromJson<int>(json['score']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      createdAtLocal: serializer.fromJson<DateTime>(json['createdAtLocal']),
      updatedAtLocal: serializer.fromJson<DateTime>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'clientId': serializer.toJson<String>(clientId),
      'serverId': serializer.toJson<int?>(serverId),
      'evaluationId': serializer.toJson<int>(evaluationId),
      'score': serializer.toJson<int>(score),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'createdAtLocal': serializer.toJson<DateTime>(createdAtLocal),
      'updatedAtLocal': serializer.toJson<DateTime>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  LocalAttempt copyWith(
          {int? localId,
          String? clientId,
          Value<int?> serverId = const Value.absent(),
          int? evaluationId,
          int? score,
          String? status,
          DateTime? startedAt,
          Value<DateTime?> finishedAt = const Value.absent(),
          DateTime? createdAtLocal,
          DateTime? updatedAtLocal,
          Value<DateTime?> serverUpdatedAt = const Value.absent(),
          String? syncStatus}) =>
      LocalAttempt(
        localId: localId ?? this.localId,
        clientId: clientId ?? this.clientId,
        serverId: serverId.present ? serverId.value : this.serverId,
        evaluationId: evaluationId ?? this.evaluationId,
        score: score ?? this.score,
        status: status ?? this.status,
        startedAt: startedAt ?? this.startedAt,
        finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
        createdAtLocal: createdAtLocal ?? this.createdAtLocal,
        updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  LocalAttempt copyWithCompanion(AttemptsTableCompanion data) {
    return LocalAttempt(
      localId: data.localId.present ? data.localId.value : this.localId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      evaluationId: data.evaluationId.present
          ? data.evaluationId.value
          : this.evaluationId,
      score: data.score.present ? data.score.value : this.score,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt:
          data.finishedAt.present ? data.finishedAt.value : this.finishedAt,
      createdAtLocal: data.createdAtLocal.present
          ? data.createdAtLocal.value
          : this.createdAtLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAttempt(')
          ..write('localId: $localId, ')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('evaluationId: $evaluationId, ')
          ..write('score: $score, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      localId,
      clientId,
      serverId,
      evaluationId,
      score,
      status,
      startedAt,
      finishedAt,
      createdAtLocal,
      updatedAtLocal,
      serverUpdatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAttempt &&
          other.localId == this.localId &&
          other.clientId == this.clientId &&
          other.serverId == this.serverId &&
          other.evaluationId == this.evaluationId &&
          other.score == this.score &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.createdAtLocal == this.createdAtLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.syncStatus == this.syncStatus);
}

class AttemptsTableCompanion extends UpdateCompanion<LocalAttempt> {
  final Value<int> localId;
  final Value<String> clientId;
  final Value<int?> serverId;
  final Value<int> evaluationId;
  final Value<int> score;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<DateTime> createdAtLocal;
  final Value<DateTime> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> syncStatus;
  const AttemptsTableCompanion({
    this.localId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.evaluationId = const Value.absent(),
    this.score = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
  });
  AttemptsTableCompanion.insert({
    this.localId = const Value.absent(),
    required String clientId,
    this.serverId = const Value.absent(),
    required int evaluationId,
    this.score = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    required DateTime createdAtLocal,
    required DateTime updatedAtLocal,
    this.serverUpdatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
  })  : clientId = Value(clientId),
        evaluationId = Value(evaluationId),
        startedAt = Value(startedAt),
        createdAtLocal = Value(createdAtLocal),
        updatedAtLocal = Value(updatedAtLocal);
  static Insertable<LocalAttempt> custom({
    Expression<int>? localId,
    Expression<String>? clientId,
    Expression<int>? serverId,
    Expression<int>? evaluationId,
    Expression<int>? score,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<DateTime>? createdAtLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? syncStatus,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (clientId != null) 'client_id': clientId,
      if (serverId != null) 'server_id': serverId,
      if (evaluationId != null) 'evaluation_id': evaluationId,
      if (score != null) 'score': score,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (createdAtLocal != null) 'created_at_local': createdAtLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
    });
  }

  AttemptsTableCompanion copyWith(
      {Value<int>? localId,
      Value<String>? clientId,
      Value<int?>? serverId,
      Value<int>? evaluationId,
      Value<int>? score,
      Value<String>? status,
      Value<DateTime>? startedAt,
      Value<DateTime?>? finishedAt,
      Value<DateTime>? createdAtLocal,
      Value<DateTime>? updatedAtLocal,
      Value<DateTime?>? serverUpdatedAt,
      Value<String>? syncStatus}) {
    return AttemptsTableCompanion(
      localId: localId ?? this.localId,
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      evaluationId: evaluationId ?? this.evaluationId,
      score: score ?? this.score,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      createdAtLocal: createdAtLocal ?? this.createdAtLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (evaluationId.present) {
      map['evaluation_id'] = Variable<int>(evaluationId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (createdAtLocal.present) {
      map['created_at_local'] = Variable<DateTime>(createdAtLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptsTableCompanion(')
          ..write('localId: $localId, ')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('evaluationId: $evaluationId, ')
          ..write('score: $score, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }
}

class $PendingOperationsTableTable extends PendingOperationsTable
    with TableInfo<$PendingOperationsTableTable, LocalPendingOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOperationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationTypeMeta =
      const VerificationMeta('operationType');
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
      'operation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextRetryAtMeta =
      const VerificationMeta('nextRetryAt');
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
      'next_retry_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        clientId,
        entityType,
        operationType,
        payload,
        createdAt,
        retryCount,
        nextRetryAt,
        lastError,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_operations_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalPendingOperation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
          _operationTypeMeta,
          operationType.isAcceptableOrUnknown(
              data['operation_type']!, _operationTypeMeta));
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
          _nextRetryAtMeta,
          nextRetryAt.isAcceptableOrUnknown(
              data['next_retry_at']!, _nextRetryAtMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPendingOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPendingOperation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      operationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation_type'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      nextRetryAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_retry_at']),
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $PendingOperationsTableTable createAlias(String alias) {
    return $PendingOperationsTableTable(attachedDatabase, alias);
  }
}

class LocalPendingOperation extends DataClass
    implements Insertable<LocalPendingOperation> {
  final int id;
  final String clientId;
  final String entityType;
  final String operationType;
  final String payload;
  final DateTime createdAt;
  final int retryCount;
  final DateTime? nextRetryAt;
  final String? lastError;
  final String status;
  const LocalPendingOperation(
      {required this.id,
      required this.clientId,
      required this.entityType,
      required this.operationType,
      required this.payload,
      required this.createdAt,
      required this.retryCount,
      this.nextRetryAt,
      this.lastError,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_id'] = Variable<String>(clientId);
    map['entity_type'] = Variable<String>(entityType);
    map['operation_type'] = Variable<String>(operationType);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  PendingOperationsTableCompanion toCompanion(bool nullToAbsent) {
    return PendingOperationsTableCompanion(
      id: Value(id),
      clientId: Value(clientId),
      entityType: Value(entityType),
      operationType: Value(operationType),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      status: Value(status),
    );
  }

  factory LocalPendingOperation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPendingOperation(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      operationType: serializer.fromJson<String>(json['operationType']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<String>(clientId),
      'entityType': serializer.toJson<String>(entityType),
      'operationType': serializer.toJson<String>(operationType),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
      'lastError': serializer.toJson<String?>(lastError),
      'status': serializer.toJson<String>(status),
    };
  }

  LocalPendingOperation copyWith(
          {int? id,
          String? clientId,
          String? entityType,
          String? operationType,
          String? payload,
          DateTime? createdAt,
          int? retryCount,
          Value<DateTime?> nextRetryAt = const Value.absent(),
          Value<String?> lastError = const Value.absent(),
          String? status}) =>
      LocalPendingOperation(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        entityType: entityType ?? this.entityType,
        operationType: operationType ?? this.operationType,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        retryCount: retryCount ?? this.retryCount,
        nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
        lastError: lastError.present ? lastError.value : this.lastError,
        status: status ?? this.status,
      );
  LocalPendingOperation copyWithCompanion(
      PendingOperationsTableCompanion data) {
    return LocalPendingOperation(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      nextRetryAt:
          data.nextRetryAt.present ? data.nextRetryAt.value : this.nextRetryAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPendingOperation(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('entityType: $entityType, ')
          ..write('operationType: $operationType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('lastError: $lastError, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clientId, entityType, operationType,
      payload, createdAt, retryCount, nextRetryAt, lastError, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPendingOperation &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.entityType == this.entityType &&
          other.operationType == this.operationType &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.nextRetryAt == this.nextRetryAt &&
          other.lastError == this.lastError &&
          other.status == this.status);
}

class PendingOperationsTableCompanion
    extends UpdateCompanion<LocalPendingOperation> {
  final Value<int> id;
  final Value<String> clientId;
  final Value<String> entityType;
  final Value<String> operationType;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<DateTime?> nextRetryAt;
  final Value<String?> lastError;
  final Value<String> status;
  const PendingOperationsTableCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.status = const Value.absent(),
  });
  PendingOperationsTableCompanion.insert({
    this.id = const Value.absent(),
    required String clientId,
    required String entityType,
    required String operationType,
    required String payload,
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.status = const Value.absent(),
  })  : clientId = Value(clientId),
        entityType = Value(entityType),
        operationType = Value(operationType),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<LocalPendingOperation> custom({
    Expression<int>? id,
    Expression<String>? clientId,
    Expression<String>? entityType,
    Expression<String>? operationType,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<DateTime>? nextRetryAt,
    Expression<String>? lastError,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (entityType != null) 'entity_type': entityType,
      if (operationType != null) 'operation_type': operationType,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (lastError != null) 'last_error': lastError,
      if (status != null) 'status': status,
    });
  }

  PendingOperationsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? clientId,
      Value<String>? entityType,
      Value<String>? operationType,
      Value<String>? payload,
      Value<DateTime>? createdAt,
      Value<int>? retryCount,
      Value<DateTime?>? nextRetryAt,
      Value<String?>? lastError,
      Value<String>? status}) {
    return PendingOperationsTableCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      entityType: entityType ?? this.entityType,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      lastError: lastError ?? this.lastError,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingOperationsTableCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('entityType: $entityType, ')
          ..write('operationType: $operationType, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('lastError: $lastError, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AttemptsTableTable attemptsTable = $AttemptsTableTable(this);
  late final $PendingOperationsTableTable pendingOperationsTable =
      $PendingOperationsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [attemptsTable, pendingOperationsTable];
}

typedef $$AttemptsTableTableCreateCompanionBuilder = AttemptsTableCompanion
    Function({
  Value<int> localId,
  required String clientId,
  Value<int?> serverId,
  required int evaluationId,
  Value<int> score,
  Value<String> status,
  required DateTime startedAt,
  Value<DateTime?> finishedAt,
  required DateTime createdAtLocal,
  required DateTime updatedAtLocal,
  Value<DateTime?> serverUpdatedAt,
  Value<String> syncStatus,
});
typedef $$AttemptsTableTableUpdateCompanionBuilder = AttemptsTableCompanion
    Function({
  Value<int> localId,
  Value<String> clientId,
  Value<int?> serverId,
  Value<int> evaluationId,
  Value<int> score,
  Value<String> status,
  Value<DateTime> startedAt,
  Value<DateTime?> finishedAt,
  Value<DateTime> createdAtLocal,
  Value<DateTime> updatedAtLocal,
  Value<DateTime?> serverUpdatedAt,
  Value<String> syncStatus,
});

class $$AttemptsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptsTableTable> {
  $$AttemptsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get evaluationId => $composableBuilder(
      column: $table.evaluationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAtLocal => $composableBuilder(
      column: $table.createdAtLocal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
      column: $table.updatedAtLocal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$AttemptsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptsTableTable> {
  $$AttemptsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get evaluationId => $composableBuilder(
      column: $table.evaluationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAtLocal => $composableBuilder(
      column: $table.createdAtLocal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
      column: $table.updatedAtLocal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$AttemptsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptsTableTable> {
  $$AttemptsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get evaluationId => $composableBuilder(
      column: $table.evaluationId, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtLocal => $composableBuilder(
      column: $table.createdAtLocal, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
      column: $table.updatedAtLocal, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$AttemptsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttemptsTableTable,
    LocalAttempt,
    $$AttemptsTableTableFilterComposer,
    $$AttemptsTableTableOrderingComposer,
    $$AttemptsTableTableAnnotationComposer,
    $$AttemptsTableTableCreateCompanionBuilder,
    $$AttemptsTableTableUpdateCompanionBuilder,
    (
      LocalAttempt,
      BaseReferences<_$AppDatabase, $AttemptsTableTable, LocalAttempt>
    ),
    LocalAttempt,
    PrefetchHooks Function()> {
  $$AttemptsTableTableTableManager(_$AppDatabase db, $AttemptsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> localId = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<int?> serverId = const Value.absent(),
            Value<int> evaluationId = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> finishedAt = const Value.absent(),
            Value<DateTime> createdAtLocal = const Value.absent(),
            Value<DateTime> updatedAtLocal = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
          }) =>
              AttemptsTableCompanion(
            localId: localId,
            clientId: clientId,
            serverId: serverId,
            evaluationId: evaluationId,
            score: score,
            status: status,
            startedAt: startedAt,
            finishedAt: finishedAt,
            createdAtLocal: createdAtLocal,
            updatedAtLocal: updatedAtLocal,
            serverUpdatedAt: serverUpdatedAt,
            syncStatus: syncStatus,
          ),
          createCompanionCallback: ({
            Value<int> localId = const Value.absent(),
            required String clientId,
            Value<int?> serverId = const Value.absent(),
            required int evaluationId,
            Value<int> score = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> finishedAt = const Value.absent(),
            required DateTime createdAtLocal,
            required DateTime updatedAtLocal,
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
          }) =>
              AttemptsTableCompanion.insert(
            localId: localId,
            clientId: clientId,
            serverId: serverId,
            evaluationId: evaluationId,
            score: score,
            status: status,
            startedAt: startedAt,
            finishedAt: finishedAt,
            createdAtLocal: createdAtLocal,
            updatedAtLocal: updatedAtLocal,
            serverUpdatedAt: serverUpdatedAt,
            syncStatus: syncStatus,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttemptsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttemptsTableTable,
    LocalAttempt,
    $$AttemptsTableTableFilterComposer,
    $$AttemptsTableTableOrderingComposer,
    $$AttemptsTableTableAnnotationComposer,
    $$AttemptsTableTableCreateCompanionBuilder,
    $$AttemptsTableTableUpdateCompanionBuilder,
    (
      LocalAttempt,
      BaseReferences<_$AppDatabase, $AttemptsTableTable, LocalAttempt>
    ),
    LocalAttempt,
    PrefetchHooks Function()>;
typedef $$PendingOperationsTableTableCreateCompanionBuilder
    = PendingOperationsTableCompanion Function({
  Value<int> id,
  required String clientId,
  required String entityType,
  required String operationType,
  required String payload,
  required DateTime createdAt,
  Value<int> retryCount,
  Value<DateTime?> nextRetryAt,
  Value<String?> lastError,
  Value<String> status,
});
typedef $$PendingOperationsTableTableUpdateCompanionBuilder
    = PendingOperationsTableCompanion Function({
  Value<int> id,
  Value<String> clientId,
  Value<String> entityType,
  Value<String> operationType,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> retryCount,
  Value<DateTime?> nextRetryAt,
  Value<String?> lastError,
  Value<String> status,
});

class $$PendingOperationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingOperationsTableTable> {
  $$PendingOperationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$PendingOperationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingOperationsTableTable> {
  $$PendingOperationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operationType => $composableBuilder(
      column: $table.operationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$PendingOperationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingOperationsTableTable> {
  $$PendingOperationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PendingOperationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PendingOperationsTableTable,
    LocalPendingOperation,
    $$PendingOperationsTableTableFilterComposer,
    $$PendingOperationsTableTableOrderingComposer,
    $$PendingOperationsTableTableAnnotationComposer,
    $$PendingOperationsTableTableCreateCompanionBuilder,
    $$PendingOperationsTableTableUpdateCompanionBuilder,
    (
      LocalPendingOperation,
      BaseReferences<_$AppDatabase, $PendingOperationsTableTable,
          LocalPendingOperation>
    ),
    LocalPendingOperation,
    PrefetchHooks Function()> {
  $$PendingOperationsTableTableTableManager(
      _$AppDatabase db, $PendingOperationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOperationsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingOperationsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingOperationsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> operationType = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime?> nextRetryAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              PendingOperationsTableCompanion(
            id: id,
            clientId: clientId,
            entityType: entityType,
            operationType: operationType,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            nextRetryAt: nextRetryAt,
            lastError: lastError,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String clientId,
            required String entityType,
            required String operationType,
            required String payload,
            required DateTime createdAt,
            Value<int> retryCount = const Value.absent(),
            Value<DateTime?> nextRetryAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              PendingOperationsTableCompanion.insert(
            id: id,
            clientId: clientId,
            entityType: entityType,
            operationType: operationType,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            nextRetryAt: nextRetryAt,
            lastError: lastError,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendingOperationsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $PendingOperationsTableTable,
        LocalPendingOperation,
        $$PendingOperationsTableTableFilterComposer,
        $$PendingOperationsTableTableOrderingComposer,
        $$PendingOperationsTableTableAnnotationComposer,
        $$PendingOperationsTableTableCreateCompanionBuilder,
        $$PendingOperationsTableTableUpdateCompanionBuilder,
        (
          LocalPendingOperation,
          BaseReferences<_$AppDatabase, $PendingOperationsTableTable,
              LocalPendingOperation>
        ),
        LocalPendingOperation,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AttemptsTableTableTableManager get attemptsTable =>
      $$AttemptsTableTableTableManager(_db, _db.attemptsTable);
  $$PendingOperationsTableTableTableManager get pendingOperationsTable =>
      $$PendingOperationsTableTableTableManager(
          _db, _db.pendingOperationsTable);
}
