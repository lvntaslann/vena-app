import 'package:equatable/equatable.dart';
import '../../model/lesson/lessons.dart';

class LessonsState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<Lesson> lessons;

  const LessonsState({
    this.isLoading = false,
    this.error,
    this.lessons = const [],
  });

  LessonsState copyWith({
    bool? isLoading,
    String? error,
    List<Lesson>? lessons,
  }) {
    return LessonsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, lessons];
}
