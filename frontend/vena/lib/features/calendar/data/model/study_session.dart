import 'package:uuid/uuid.dart';

class StudySession {
  final String id;
  final String startingTime;
  final String endTime;
  final String lessons;
  final String lessonsSubject;
  final double lessonsDuration;
  final bool isCompleted;

  StudySession({
    required this.id,
    required this.startingTime,
    required this.endTime,
    required this.lessons,
    required this.lessonsSubject,
    required this.lessonsDuration,
    required this.isCompleted,
  });

factory StudySession.fromJson(Map<String, dynamic> json) {
  final uuid = Uuid();
  final dynamic rawId = json['id'];
  final String id = (rawId is String && rawId.isNotEmpty)
      ? rawId
      : uuid.v4();

  return StudySession(
    id: id,
    startingTime: json['startingTime'] ?? '',
    endTime: json['endTime'] ?? '',
    lessons: json['lessons'] ?? '',
    lessonsSubject: json['lessonsSubject'] ?? '',
    lessonsDuration: (json['lessonsDuration'] as num?)?.toDouble() ?? 0.0,
    isCompleted: json['completed'] ?? false,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startingTime': startingTime,
      'endTime': endTime,
      'lessons': lessons,
      'lessonsSubject': lessonsSubject,
      'lessonsDuration': lessonsDuration,
      'completed': isCompleted,
    };
  }

  StudySession copyWith({
    String? id,
    String? startingTime,
    String? endTime,
    String? lessons,
    String? lessonsSubject,
    double? lessonsDuration,
    bool? isCompleted,
  }) {
    return StudySession(
      id: id ?? this.id,
      startingTime: startingTime ?? this.startingTime,
      endTime: endTime ?? this.endTime,
      lessons: lessons ?? this.lessons,
      lessonsSubject: lessonsSubject ?? this.lessonsSubject,
      lessonsDuration: lessonsDuration ?? this.lessonsDuration,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
