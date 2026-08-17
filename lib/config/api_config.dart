class ApiConfig {
  /// Base URL configured via `--dart-define=API_BASE_URL=...`
  /// Defaults to `http://localhost:3000/api` for Web/Desktop development.
  /// For Android Emulator use `--dart-define=API_BASE_URL=http://10.0.2.2:3000/api`.
  /// For Physical Android device use `--dart-define=API_BASE_URL=http://<PC-LAN-IP>:3000/api`.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  /// Endpoint to verify NestJS backend health status
  static String get healthEndpoint => '$baseUrl/health';
}
