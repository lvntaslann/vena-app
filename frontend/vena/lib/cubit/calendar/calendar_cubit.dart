import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vena/utils/token.dart';
import '../../model/lesson/lessons.dart';
import '../../model/calendar/study_meta.dart';
import '../../model/calendar/study_plan.dart';
import '../../services/calendar/calendar_services.dart';
import 'calendar_state.dart';
import 'package:http/http.dart' as http;

class CalendarCubit extends Cubit<CalendarState> {
  final CalendarService service;

  CalendarCubit(this.service) : super(CalendarState());
  final firebaseUrl =
      '';
  Future<void> generateCalendar(Map<String, dynamic> requestBody) async {
    emit(state.copyWith(isGenerating: true, error: null));
    try {
      final rawData = await service.generateRawPlan(requestBody);

      final StudyMeta meta = StudyMeta.fromJson(rawData['meta']);

      final plans = rawData.entries
          .where((entry) => entry.key != 'meta')
          .map((entry) => StudyPlan.fromJson(entry.key, entry.value))
          .toList();

      emit(state.copyWith(
          isGenerating: false,
          plans: plans,
          meta: meta,
          weeklyCompletionRate: 0));
      await savePlansToBackend(plans, meta);
      debugPrint("kaydetme İşlemi tamamlandı");
    } catch (e) {
      emit(state.copyWith(isGenerating: false, error: e.toString()));
    }
  }

  Map<String, dynamic> createRequestBody({
    required List<Lesson> lessons,
    required String startingTime,
    required String endTime,
    required int breakTimeMinutes,
  }) {
    return {
      "examCalendar": lessons.map((lesson) {
        return {
          "lesson": lesson.name,
          "examDate": lesson.examDate.toIso8601String().split("T").first,
          "diffculty": lesson.difficulty,
          "completionStatus": (lesson.completionStatus) ? 100 : 0,
          "lessonsSubjects": lesson.lessonsSubject,
        };
      }).toList(),
      "startingTime": startingTime,
      "endTime": endTime,
      "breakTimeMinutes": breakTimeMinutes,
    };
  }

  Future<void> savePlansToBackend(List<StudyPlan> plans, StudyMeta meta) async {
    final url = Uri.parse(
        '$firebaseUrl/api/study-plan');
    final userId = await Token.getUserId();

    final body = {
      "userId": userId,
      "meta": {
        "weeklyTotalHours": meta.weeklyTotalHours,
        "aiConfidence": meta.aiConfidence
      },
      "plans": plans
          .map((p) => {
                "date": p.date,
                "day": p.day,
                "dailyTotalHours": p.dailyTotalHours,
                "sessions": p.sessions
                    .map((s) => {
                          "id": s.id,
                          "startingTime": s.startingTime,
                          "endTime": s.endTime,
                          "lessons": s.lessons,
                          "lessonsSubject": s.lessonsSubject,
                          "lessonsDuration": s.lessonsDuration,
                          "completed": false
                        })
                    .toList(),
              })
          .toList()
    };

    final response = await http.post(url,
        body: jsonEncode(body), headers: {"Content-Type": "application/json"});

    debugPrint("kullanıcı id : $userId");
    if (response.statusCode != 200) {
      throw Exception('Backend kaydetme başarısız: ${response.body}');
    }
  }

  Future<void> fetchPlansFromBackend() async {
    final userId = await Token.getUserId();
    emit(state.copyWith(isRefreshing: true));
    final url = Uri.parse(
        '$firebaseUrl/study-plan/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final StudyMeta meta = StudyMeta.fromJson(data['meta']);
      final plans = (data['plans'] as List<dynamic>)
          .map((e) => StudyPlan.fromJson(e['date'], e))
          .toList();

      emit(state.copyWith(plans: plans, meta: meta, isRefreshing: false));
    } else {
      emit(state.copyWith(error: "Planlar alınamadı", isRefreshing: false));
    }
  }

  Future<void> fetchDailyPlan(String date) async {
    final userId = await Token.getUserId();
    debugPrint("User ID = $userId");
    emit(state.copyWith(isLoading: true));
    debugPrint("fetchDailyPlan için date: $date");

    final url = Uri.parse(
        '$firebaseUrl/study-plan/$userId/$date');
    final response = await http.get(url);
    debugPrint(response.body);
    debugPrint("fetchDailyPlan response status: ${response.statusCode}");
debugPrint("fetchDailyPlan response body: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final dailyPlan = StudyPlan.fromJson(date, data);

      emit(state.copyWith(dailyPlan: dailyPlan, isLoading: false));
      _calculateWeeklyStats();
    } else {
      emit(state.copyWith(error: "Günlük plan alınamadı", isLoading: false));
    }
  }

  void _calculateWeeklyStats() {
    final allSessions = state.plans.expand((plan) => plan.sessions).toList();
    if (allSessions.isEmpty) {
      emit(state.copyWith(weeklyCompletionRate: 0.0, focusScore: 0.0));
      return;
    }

    final total = allSessions.length;
    final completed = allSessions.where((s) => s.isCompleted).length;
    final totalDuration =
        allSessions.fold<double>(0, (sum, s) => sum + s.lessonsDuration);
    final completedDuration = allSessions
        .where((s) => s.isCompleted)
        .fold<double>(0, (sum, s) => sum + s.lessonsDuration);

    final completionRate = completed / total;
    final focusScore = (completedDuration / totalDuration).clamp(0.0, 1.0);

    emit(state.copyWith(
      weeklyCompletionRate: completionRate,
      focusScore: focusScore,
    ));
  }

  Future<void> toggleSessionCompletion(String date, String sessionId) async {
    try {
      final String? userId = await Token.getUserId();
      if (userId == null) {
        emit(state.copyWith(error: "Kullanıcı ID bulunamadı"));
        return;
      }

      final currentSession = state.plans
          .firstWhere((plan) => plan.date == date)
          .sessions
          .firstWhere((s) => s.id == sessionId);

      final newCompletedStatus = !currentSession.isCompleted;

      debugPrint(
          "toggleSessionCompletion çağrıldı: $date, $sessionId, yeni durum: $newCompletedStatus");

      await service.updateSessionCompletion(
        userId: userId,
        planDate: date,
        sessionId: sessionId,
        completed: newCompletedStatus,
      );

      debugPrint("Backend güncelleme başarılı");

      final updatedPlans = state.plans.map((plan) {
        if (plan.date == date) {
          final updatedSessions = plan.sessions.map((session) {
            if (session.id == sessionId) {
              return session.copyWith(isCompleted: newCompletedStatus);
            }
            return session;
          }).toList();

          return plan.copyWith(sessions: updatedSessions);
        }
        return plan;
      }).toList();

      emit(state.copyWith(plans: updatedPlans));
      _calculateWeeklyStats();
    } catch (e) {
      debugPrint("toggleSessionCompletion hatası: $e");
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<Map<String, dynamic>> fetchResources(
      Map<String, dynamic> requestBody) async {
    emit(state.copyWith(isGeneratingResources: true, error: null));

    try {
      debugPrint("islem basladi");
      final resources = await service.getResources(requestBody);
      debugPrint("işlem bitti");
      emit(state.copyWith(isGeneratingResources: false));
      return resources;
    } catch (e) {
      emit(state.copyWith(isGeneratingResources: false, error: e.toString()));
      rethrow;
    }
  }
}
