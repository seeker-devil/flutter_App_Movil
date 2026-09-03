import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:training_quiz_app/app/app_router.dart';
import 'package:training_quiz_app/local/database/app_database.dart';
import 'package:training_quiz_app/local/sync/sync_service.dart';
import 'package:training_quiz_app/providers/app_providers.dart';
import 'package:training_quiz_app/services/auth_service.dart';
import 'package:training_quiz_app/services/secure_session_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late SecureSessionStorage secureStorage;

  setUp(() {
    // Memory-backed FlutterSecureStorage for testing
    FlutterSecureStorage.setMockInitialValues({});
    secureStorage = SecureSessionStorage();
    // In-memory Drift database for testing
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('1. SecureSessionStorage Tests', () {
    test('Guardar, leer y eliminar accessToken cifrado', () async {
      const token = 'header.payload.signature_jwt_test';

      await secureStorage.saveAccessToken(token);
      final readToken = await secureStorage.readAccessToken();
      expect(readToken, token);

      await secureStorage.deleteAccessToken();
      final deletedToken = await secureStorage.readAccessToken();
      expect(deletedToken, isNull);
    });

    test('clearSession elimina todos los tokens', () async {
      await secureStorage.saveAccessToken('my_token');
      await secureStorage.clearSession();

      final token = await secureStorage.readAccessToken();
      expect(token, isNull);
    });
  });

  group('2. AuthService Session Persistence & Error Resilience Tests', () {
    test('Sesión restaurada exitosamente cuando token existe y es válido (200 OK)', () async {
      await secureStorage.saveAccessToken('valid_jwt_token');

      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {'id': 1, 'email': 'user@safeaccess90.com', 'role': 'ADMIN'}
          }),
          200,
        );
      });

      final authService = AuthService(
        secureStorage: secureStorage,
        db: db,
        httpClient: mockClient,
      );

      final user = await authService.restoreSession();
      expect(user, isNotNull);
      expect(user?.email, 'user@safeaccess90.com');
      expect(await secureStorage.readAccessToken(), 'valid_jwt_token');
    });

    test('Respuesta HTTP 401 (token expirado/inválido) sí produce logout y elimina token', () async {
      await secureStorage.saveAccessToken('expired_jwt_token');

      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Unauthorized'}),
          401,
        );
      });

      final authService = AuthService(
        secureStorage: secureStorage,
        db: db,
        httpClient: mockClient,
      );

      final user = await authService.restoreSession();
      expect(user, isNull);
      expect(await secureStorage.readAccessToken(), isNull);
    });

    test('Fallo de red / offline / excepcion NO produce logout y conserva la sesión', () async {
      await secureStorage.saveAccessToken('saved_jwt_token');

      final mockClient = MockClient((request) async {
        throw Exception('Network unreachable');
      });

      final authService = AuthService(
        secureStorage: secureStorage,
        db: db,
        httpClient: mockClient,
      );

      final user = await authService.restoreSession();
      expect(user, isNotNull);
      expect(user?.email, contains('offline'));
      expect(await secureStorage.readAccessToken(), 'saved_jwt_token');
    });

    test('Error HTTP 500/503 del servidor NO produce logout y conserva el token', () async {
      await secureStorage.saveAccessToken('saved_jwt_token');

      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final authService = AuthService(
        secureStorage: secureStorage,
        db: db,
        httpClient: mockClient,
      );

      final user = await authService.restoreSession();
      expect(user, isNotNull);
      expect(await secureStorage.readAccessToken(), 'saved_jwt_token');
    });
  });

  group('3. AuthNotifier & Race Condition Prevention Tests', () {
    test('login exitoso -> authState es authenticated (data(user)) y no vuelve a unauthenticated', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'accessToken': 'new_valid_token_123',
              'user': {'id': 1, 'email': 'admin@safeaccess90.com', 'role': 'ADMIN'}
            }
          }),
          200,
        );
      });

      final authService = AuthService(
        secureStorage: secureStorage,
        db: db,
        httpClient: mockClient,
      );

      final notifier = AuthNotifier(authService);
      await notifier.login('admin@safeaccess90.com', 'admin123');

      expect(notifier.state.valueOrNull, isNotNull);
      expect(notifier.state.valueOrNull?.email, 'admin@safeaccess90.com');
      expect(await secureStorage.readAccessToken(), 'new_valid_token_123');
    });

    test('login y restoreSession concurrentes no pisan el estado autenticado', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/login')) {
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'accessToken': 'login_token_abc',
                'user': {'id': 99, 'email': 'login_user@safeaccess90.com', 'role': 'USER'}
              }
            }),
            200,
          );
        } else {
          // Slow restore response returning null
          await Future.delayed(const Duration(milliseconds: 100));
          return http.Response(jsonEncode({'message': 'Unauthorized'}), 401);
        }
      });

      final authService = AuthService(
        secureStorage: secureStorage,
        db: db,
        httpClient: mockClient,
      );

      final notifier = AuthNotifier(authService);
      // Trigger login concurrently while restoreSession is running
      final loginFuture = notifier.login('admin@safeaccess90.com', 'admin123');
      await loginFuture;

      // Wait a bit to let any background restoreSession complete
      await Future.delayed(const Duration(milliseconds: 150));

      // The authenticated user from login MUST remain intact and not overwritten
      expect(notifier.state.valueOrNull, isNotNull);
      expect(notifier.state.valueOrNull?.email, 'login_user@safeaccess90.com');
      expect(await secureStorage.readAccessToken(), 'login_token_abc');
    });
  });

  group('4. RouterNotifier & GoRouter Redirect Logic Tests', () {
    test('estado loading -> router redirect es null (no envía a /login prematuramente)', () {
      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith((ref) => MockLoadingAuthNotifier(AuthService(secureStorage: secureStorage, db: db))),
        ],
      );

      final routerNotifier = container.read(routerNotifierProvider);
      final fakeState = FakeGoRouterState('/login');

      final redirectResult = routerNotifier.redirect(FakeBuildContext(), fakeState);
      expect(redirectResult, isNull);
    });

    test('authenticated estando en /login -> redirect a pantalla principal (/)', () {
      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith((ref) => MockAuthenticatedAuthNotifier(AuthService(secureStorage: secureStorage, db: db))),
        ],
      );

      final routerNotifier = container.read(routerNotifierProvider);
      final fakeState = FakeGoRouterState('/login');

      final redirectResult = routerNotifier.redirect(FakeBuildContext(), fakeState);
      expect(redirectResult, '/');
    });

    test('authenticated estando en / -> no redirect (null)', () {
      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith((ref) => MockAuthenticatedAuthNotifier(AuthService(secureStorage: secureStorage, db: db))),
        ],
      );

      final routerNotifier = container.read(routerNotifierProvider);
      final fakeState = FakeGoRouterState('/');

      final redirectResult = routerNotifier.redirect(FakeBuildContext(), fakeState);
      expect(redirectResult, isNull);
    });

    test('unauthenticated estando en ruta protegida (/) -> redirect a /login', () {
      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith((ref) => MockUnauthenticatedAuthNotifier(AuthService(secureStorage: secureStorage, db: db))),
        ],
      );

      final routerNotifier = container.read(routerNotifierProvider);
      final fakeState = FakeGoRouterState('/');

      final redirectResult = routerNotifier.redirect(FakeBuildContext(), fakeState);
      expect(redirectResult, '/login');
    });
  });

  group('5. AppDatabase & Queue (Drift SQLite) Tests', () {
    test('Insertar y leer intentos en base de datos Drift', () async {
      final now = DateTime.now();
      const clientId = 'uuid-test-123';

      await db.saveAttempt(
        AttemptsTableCompanion.insert(
          clientId: clientId,
          evaluationId: 1,
          score: const drift.Value(90),
          status: const drift.Value('APPROVED'),
          startedAt: now,
          createdAtLocal: now,
          updatedAtLocal: now,
          syncStatus: const drift.Value('PENDING_CREATE'),
        ),
      );

      final attempts = await db.getAllAttempts();
      expect(attempts.length, 1);
      expect(attempts.first.clientId, clientId);
      expect(attempts.first.syncStatus, 'PENDING_CREATE');
    });
  });

  group('6. SyncService & Backoff Exponencial Tests', () {
    test('Cálculo correcto de la fórmula de backoff exponencial', () {
      final mockHttpClient = MockClient((_) async => http.Response('{}', 200));
      final syncService = SyncService(
        db: db,
        secureStorage: secureStorage,
        httpClient: mockHttpClient,
      );

      expect(syncService.calculateBackoffSeconds(1), 2);
      expect(syncService.calculateBackoffSeconds(2), 4);
      expect(syncService.calculateBackoffSeconds(3), 8);
      expect(syncService.calculateBackoffSeconds(4), 16);
    });
  });

  group('7. Real Logout Cleanup Tests', () {
    test('Logout manual elimina SecureStorage y limpia todas las tablas de Drift', () async {
      await secureStorage.saveAccessToken('session_token_xyz');

      final now = DateTime.now();
      await db.saveAttempt(
        AttemptsTableCompanion.insert(
          clientId: 'to-be-deleted',
          evaluationId: 1,
          startedAt: now,
          createdAtLocal: now,
          updatedAtLocal: now,
        ),
      );

      final authService = AuthService(
        secureStorage: secureStorage,
        db: db,
      );

      await authService.logout();

      final token = await secureStorage.readAccessToken();
      expect(token, isNull);

      final attempts = await db.getAllAttempts();
      expect(attempts.isEmpty, isTrue);
    });
  });
}

// Mock Notifiers & Helpers for Router Tests
class MockLoadingAuthNotifier extends AuthNotifier {
  MockLoadingAuthNotifier(super.authService) {
    state = const AsyncValue.loading();
  }
}

class MockAuthenticatedAuthNotifier extends AuthNotifier {
  MockAuthenticatedAuthNotifier(super.authService) {
    state = AsyncValue.data(AuthUser(id: 1, email: 'test@safeaccess90.com', role: 'ADMIN'));
  }
}

class MockUnauthenticatedAuthNotifier extends AuthNotifier {
  MockUnauthenticatedAuthNotifier(super.authService) {
    state = const AsyncValue.data(null);
  }
}

class FakeGoRouterState implements GoRouterState {
  final String _matchedLocation;

  FakeGoRouterState(this._matchedLocation);

  @override
  String get matchedLocation => _matchedLocation;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
