class Lesson {
  final String? id;
  final String name;
  final List<String> lessonsSubject;
  final DateTime examDate;
  final String difficulty;
  final bool completionStatus;

  Lesson({
    required this.id,
    required this.name,
    required this.lessonsSubject,
    required this.examDate,
    required this.difficulty,
    required this.completionStatus,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      name: json['lesson'] ?? '',
      lessonsSubject: List<String>.from(json['lessonsSubject'] ?? []),
      examDate: DateTime.parse(json['examDate'] ?? DateTime.now().toIso8601String()),
      difficulty: json['difficulty'] ?? '',
      completionStatus: json['completionStatus'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "lesson": name,
      "lessonsSubject": lessonsSubject,
      "examDate": examDate.toIso8601String(),
      "difficulty": difficulty,
      "completionStatus": completionStatus,
    };
  }

  Lesson copyWith({
    String? id,
    String? name,
    List<String>? lessonsSubject,
    DateTime? examDate,
    String? difficulty,
    bool? completionStatus,
  }) {
    return Lesson(
      id: id ?? this.id,
      name: name ?? this.name,
      lessonsSubject: lessonsSubject ?? this.lessonsSubject,
      examDate: examDate ?? this.examDate,
      difficulty: difficulty ?? this.difficulty,
      completionStatus: completionStatus ?? this.completionStatus,
    );
  }
}
