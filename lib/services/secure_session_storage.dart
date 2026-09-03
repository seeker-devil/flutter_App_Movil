import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSessionStorage {
  static const String _accessTokenKey = 'safeaccess_access_token';
  
  final FlutterSecureStorage _storage;

  SecureSessionStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save access token securely in encrypted OS KeyStore/Keychain
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Read access token securely
  Future<String?> readAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Delete access token
  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  /// Clear all secure session storage (logout)
  Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}
