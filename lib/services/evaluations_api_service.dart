import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'secure_session_storage.dart';

class EvaluationItem {
  final int id;
  final String title;
  final int passingScore;
  final bool active;
  final DateTime? createdAt;

  EvaluationItem({
    required this.id,
    required this.title,
    required this.passingScore,
    required this.active,
    this.createdAt,
  });

  factory EvaluationItem.fromJson(Map<String, dynamic> json) {
    return EvaluationItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      passingScore: json['passingScore'] as int? ?? 70,
      active: json['active'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class EvaluationsApiService {
  final SecureSessionStorage secureStorage;
  final http.Client httpClient;

  EvaluationsApiService({
    required this.secureStorage,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Future<Map<String, String>> _getHeaders() async {
    final token = await secureStorage.readAccessToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Get all evaluations from backend
  Future<List<EvaluationItem>> fetchEvaluations() async {
    final headers = await _getHeaders();
    final response = await httpClient.get(
      Uri.parse('${ApiConfig.baseUrl}/evaluations'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'] as List? ?? [];
      return dataList.map((item) => EvaluationItem.fromJson(item)).toList();
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Error al obtener evaluaciones');
    }
  }

  /// Create a new evaluation (Admin only)
  Future<EvaluationItem> createEvaluation({
    required String title,
    required int passingScore,
    bool active = true,
  }) async {
    final headers = await _getHeaders();
    final response = await httpClient.post(
      Uri.parse('${ApiConfig.baseUrl}/evaluations'),
      headers: headers,
      body: jsonEncode({
        'title': title,
        'passingScore': passingScore,
        'active': active,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return EvaluationItem.fromJson(json['data']);
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Error al crear evaluación');
    }
  }

  /// Update an evaluation (Admin only)
  Future<EvaluationItem> updateEvaluation(
    int id, {
    String? title,
    int? passingScore,
    bool? active,
  }) async {
    final headers = await _getHeaders();
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (passingScore != null) body['passingScore'] = passingScore;
    if (active != null) body['active'] = active;

    final response = await httpClient.patch(
      Uri.parse('${ApiConfig.baseUrl}/evaluations/$id'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return EvaluationItem.fromJson(json['data']);
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Error al actualizar evaluación');
    }
  }

  /// Perform logical delete (active = false) of an evaluation (Admin only)
  Future<EvaluationItem> deleteEvaluation(int id) async {
    final headers = await _getHeaders();
    final response = await httpClient.delete(
      Uri.parse('${ApiConfig.baseUrl}/evaluations/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return EvaluationItem.fromJson(json['data']);
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Error al desactivar evaluación');
    }
  }
}
