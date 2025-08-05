import 'study_session.dart';

class StudyPlan {
  final String date;
  final String day;
  final List<StudySession> sessions;
  final double dailyTotalHours;
  double weeklyTotalHours;
  double aiConfidence;

  StudyPlan({
    required this.date,
    required this.day,
    required this.sessions,
    required this.dailyTotalHours,
    this.weeklyTotalHours = 0.0,
    this.aiConfidence = 0.0,
  });

  factory StudyPlan.fromJson(String date, Map<String, dynamic> json) {
    final day = json['day'] ?? '';
    final plan = (json['plan'] as List<dynamic>?) ?? [];

    final sessions = plan
        .map((sessionJson) => StudySession.fromJson(sessionJson))
        .toList();

    return StudyPlan(
      date: date,
      day: day,
      sessions: sessions,
      dailyTotalHours: (json['dailyTotalHours'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'plan': sessions.map((s) => s.toJson()).toList(),
      'dailyTotalHours': dailyTotalHours,
    };
  }

  StudyPlan copyWith({
    String? date,
    String? day,
    List<StudySession>? sessions,
    double? dailyTotalHours,
    double? weeklyTotalHours,
    double? aiConfidence,
    
  }) {
    return StudyPlan(
      date: date ?? this.date,
      day: day ?? this.day,
      sessions: sessions ?? this.sessions,
      dailyTotalHours: dailyTotalHours ?? this.dailyTotalHours,
      weeklyTotalHours: weeklyTotalHours ?? this.weeklyTotalHours,
      aiConfidence: aiConfidence ?? this.aiConfidence,
    );
  }
}
