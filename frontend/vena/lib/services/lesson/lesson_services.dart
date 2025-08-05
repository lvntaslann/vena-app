import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import '../../model/lesson/lessons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonsService {
  final String baseUrl =
      '';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idToken');
  }

  Future<List<Lesson>> getLessons() async {
    final token = await _getToken();
    debugPrint(token);
    if (token == null) {
      throw Exception('Kullanıcı girişi yapılmamış, token bulunamadı.');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/lessons/get-lessons'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final lessonsList = data['lessons'] as List;
      return lessonsList.map((json) => Lesson.fromJson(json)).toList();
    } else {
      throw Exception('Dersler yüklenemedi: ${response.body}');
    }
  }

  Future<String> addLesson(Lesson lesson) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Kullanıcı girişi yapılmamış, token bulunamadı.');
    }
    debugPrint(token);
    final response = await http.post(
      Uri.parse('$baseUrl/lessons/add-lessons'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(lesson.toJson()),
    );
    debugPrint(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint('Ders eklenemedi, status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      throw Exception('Ders eklenemedi: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['lessonId'];
  }

  Future<void> deleteLesson(String id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Kullanıcı girişi yapılmamış, token bulunamadı.');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/lessons/delete-lessons/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint(response.body);

    if (response.statusCode != 200) {
      throw Exception('Ders silinemedi');
    }
  }

  Future<void> updateLesson(String id, Lesson lesson) async {
    debugPrint('Service updateLesson başladı');
    final token = await _getToken();
    if (token == null) throw Exception('Token yok');

    final response = await http.put(
      Uri.parse('$baseUrl/lessons/update-lessons/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(lesson.toJson()),
    );

    debugPrint('Service updateLesson response status: ${response.statusCode}');
    debugPrint('Service updateLesson response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Ders güncellenemedi');
    }
  }
}
