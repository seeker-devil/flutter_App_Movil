import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class HealthResponse {
  final bool success;
  final String message;
  final String? timestamp;
  final String? error;

  HealthResponse({
    required this.success,
    required this.message,
    this.timestamp,
    this.error,
  });

  factory HealthResponse.fromJson(Map<String, dynamic> json) {
    return HealthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      timestamp: json['timestamp'],
    );
  }
}

class HealthApiService {
  final http.Client client;

  HealthApiService({http.Client? client}) : client = client ?? http.Client();

  /// Consumes backend GET /api/health endpoint
  Future<HealthResponse> checkHealth() async {
    try {
      final uri = Uri.parse(ApiConfig.healthEndpoint);
      final response = await client.get(uri).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return HealthResponse.fromJson(data);
      } else {
        return HealthResponse(
          success: false,
          message: 'No fue posible conectar con el backend (Código: ${response.statusCode})',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      return HealthResponse(
        success: false,
        message: 'No fue posible conectar con el backend. Verifica que esté en ejecución.',
        error: e.toString(),
      );
    }
  }
}
