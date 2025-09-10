import '../../data/model/study_meta.dart';
import '../../data/model/study_plan.dart';

class CalendarState {
  final bool isLoading;
  final bool isGenerating;
  final bool isRefreshing;
  final bool isGeneratingResources;
  final List<StudyPlan> plans;
  final StudyMeta? meta;
  final StudyPlan? dailyPlan;
  final String? error;
  final double? weeklyCompletionRate;
  final double? focusScore;

  CalendarState({
    this.isLoading = false,
    this.isGenerating = false,
    this.isRefreshing = false,
    this.isGeneratingResources = false,
    this.plans = const [],
    this.meta,
    this.dailyPlan,
    this.error,
    this.weeklyCompletionRate,
    this.focusScore,
  });

  CalendarState copyWith({
    bool? isLoading,
    bool? isGenerating,
    bool? isRefreshing,
    bool? isGeneratingResources,
    List<StudyPlan>? plans,
    StudyMeta? meta,
    StudyPlan? dailyPlan,
    String? error,
    double? weeklyCompletionRate,
    double? focusScore,  
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isGeneratingResources: isGeneratingResources ?? this.isGeneratingResources,
      plans: plans ?? this.plans,
      meta: meta ?? this.meta,
      dailyPlan: dailyPlan ?? this.dailyPlan,
      weeklyCompletionRate: weeklyCompletionRate ?? this.weeklyCompletionRate,
      focusScore: focusScore ?? this.focusScore,
      error: error,

    );
  }

  
}
