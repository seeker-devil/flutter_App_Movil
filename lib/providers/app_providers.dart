import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/database/app_database.dart';
import '../local/sync/sync_service.dart';
import '../services/auth_service.dart';
import '../services/secure_session_storage.dart';

/// AppDatabase singleton provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// SecureSessionStorage provider
final secureStorageProvider = Provider<SecureSessionStorage>((ref) {
  return SecureSessionStorage();
});

/// AuthService provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    secureStorage: ref.watch(secureStorageProvider),
    db: ref.watch(appDatabaseProvider),
  );
});

/// SyncService provider
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    db: ref.watch(appDatabaseProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

/// Auth State Notifier
class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final AuthService _authService;
  bool _isPerformingLogin = false;

  AuthNotifier(this._authService) : super(const AsyncValue.loading()) {
    restoreSession();
  }

  /// Restore user session on app boot
  Future<void> restoreSession() async {
    if (_isPerformingLogin) {
      debugPrint('[AUTH][RESTORE] Ignorado porque login() está en progreso');
      return;
    }
    debugPrint('[AUTH][STATE] Iniciando restoreSession...');
    state = const AsyncValue.loading();
    try {
      final user = await _authService.restoreSession();
      if (_isPerformingLogin) {
        debugPrint('[AUTH][RESTORE] Ignorando resultado porque login() tomó precedencia');
        return;
      }
      debugPrint('[AUTH][STATE] authenticated = ${user != null} (${user?.email})');
      state = AsyncValue.data(user);
    } catch (e, st) {
      if (_isPerformingLogin) return;
      debugPrint('[AUTH][STATE] error en restoreSession: $e');
      state = AsyncValue.error(e, st);
    }
  }

  /// Perform login
  Future<void> login(String email, String password) async {
    _isPerformingLogin = true;
    debugPrint('[AUTH][STATE] Iniciando login para $email...');
    state = const AsyncValue.loading();
    try {
      final user = await _authService.login(email, password);
      debugPrint('[AUTH][STATE] login exitoso -> authenticated = true (${user.email})');
      state = AsyncValue.data(user);
    } catch (e, st) {
      debugPrint('[AUTH][STATE] login fallido -> $e');
      state = AsyncValue.error(e, st);
      rethrow;
    } finally {
      _isPerformingLogin = false;
    }
  }

  /// Perform logout and clear all local storage
  Future<void> logout() async {
    debugPrint('[AUTH][STATE] Ejecutando logout...');
    state = const AsyncValue.loading();
    try {
      await _authService.logout();
      debugPrint('[AUTH][STATE] logout completado -> authenticated = false');
      state = const AsyncValue.data(null);
    } catch (e, st) {
      debugPrint('[AUTH][STATE] error en logout: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

/// Connectivity status stream provider
final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Stream of local attempts from Drift DB
final attemptsStreamProvider = StreamProvider<List<LocalAttempt>>((ref) {
  return ref.watch(appDatabaseProvider).watchAllAttempts();
});
