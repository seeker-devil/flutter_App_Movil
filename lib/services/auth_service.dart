import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'secure_session_storage.dart';
import '../local/database/app_database.dart';

class AuthUser {
  final int id;
  final String email;
  final String role;

  AuthUser({required this.id, required this.email, required this.role});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int,
      email: json['email'] ?? '',
      role: json['role'] ?? 'PARTICIPANT',
    );
  }
}

class AuthService {
  final SecureSessionStorage secureStorage;
  final AppDatabase db;
  final http.Client httpClient;

  AuthService({
    required this.secureStorage,
    required this.db,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Perform login against backend NestJS API
  Future<AuthUser> login(String email, String password) async {
    final response = await httpClient.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    debugPrint('[AUTH][LOGIN] respuesta HTTP = ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      final data = json['data'];
      final accessToken = data['accessToken'] as String?;
      debugPrint('[AUTH][LOGIN] token recibido = ${accessToken != null && accessToken.isNotEmpty}');

      if (accessToken != null && accessToken.isNotEmpty) {
        await secureStorage.saveAccessToken(accessToken);
        final savedToken = await secureStorage.readAccessToken();
        debugPrint('[AUTH][LOGIN] token guardado = ${savedToken != null && savedToken.isNotEmpty}');
      } else {
        debugPrint('[AUTH][LOGIN] token guardado = false');
      }

      final userData = AuthUser.fromJson(data['user']);
      return userData;
    } else {
      final json = jsonDecode(response.body);
      final message = json['message'] ?? 'Credenciales inválidas';
      throw Exception(message);
    }
  }

  /// Restore session from encrypted secure storage
  Future<AuthUser?> restoreSession() async {
    debugPrint('[AUTH][RESTORE] inicio');
    final token = await secureStorage.readAccessToken();
    final hasToken = token != null && token.isNotEmpty;
    debugPrint('[AUTH][RESTORE] token encontrado = $hasToken');

    if (!hasToken) {
      return null;
    }

    try {
      final response = await httpClient.get(
        Uri.parse('${ApiConfig.baseUrl}/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 5));

      debugPrint('[AUTH][ME] status = ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        return AuthUser(
          id: data['id'] as int,
          email: data['email'] ?? 'usuario@safeaccess90.com',
          role: data['role'] ?? 'PARTICIPANT',
        );
      } else if (response.statusCode == 401) {
        debugPrint('[AUTH][RESTORE] 401 Unauthorized recibido -> Limpiando token');
        await secureStorage.clearSession();
        return null;
      } else {
        debugPrint('[AUTH][RESTORE] HTTP ${response.statusCode} -> Conservando sesión local');
        return AuthUser(
          id: 1,
          email: 'usuario.local@safeaccess90.com',
          role: 'PARTICIPANT',
        );
      }
    } catch (e) {
      debugPrint('[AUTH][RESTORE] Error de red / Timeout ($e) -> Conservando sesión offline');
      return AuthUser(
        id: 1,
        email: 'usuario.offline@safeaccess90.com',
        role: 'PARTICIPANT',
      );
    }
  }

  /// Real logout: clears secure storage AND local Drift database tables completely
  Future<void> logout() async {
    debugPrint('[AUTH][LOGOUT] Ejecutando limpieza total');
    await secureStorage.clearSession();
    await db.clearAllTablesOnLogout();
  }
}
