import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/study_plan.dart';

class CalendarService {
  final String baseUrl = 'http://10.0.2.2:7000';
  final firebaseUrl =
      '';

  Future<Map<String, dynamic>> generateRawPlan(
      Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/generate-plan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Takvim oluşturulurken hata oluştu.');
    }
  }

  Future<List<StudyPlan>> generatePlan(Map<String, dynamic> requestBody) async {
    final rawData = await generateRawPlan(requestBody);

    final List<StudyPlan> plans = [];
    rawData.forEach((day, sessions) {
      if (day == 'meta') return;
      plans.add(StudyPlan.fromJson(day, sessions));
    });

    return plans;
  }

  Future<void> updateSessionCompletion({
    required String userId,
    required String planDate,
    required String sessionId,
    required bool completed,
  }) async {
    final url = Uri.parse(
        '$firebaseUrl/study-plan/$userId/$planDate/session/$sessionId');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'completed': completed}),
    );

    if (response.statusCode != 200) {
      throw Exception('Session completion update failed');
    }
  }

  Future<Map<String, dynamic>> getResources(
      Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-resources'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Kaynaklar alınırken hata oluştu.');
    }
  }
}
