class StudyMeta {
  final double weeklyTotalHours;
  final double aiConfidence;

  StudyMeta({
    required this.weeklyTotalHours,
    required this.aiConfidence,
  });

  factory StudyMeta.fromJson(Map<String, dynamic> json) {
    return StudyMeta(
      weeklyTotalHours: (json['weeklyTotalHours'] as num).toDouble(),
      aiConfidence: (json['aiConfidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
