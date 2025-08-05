import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/lesson/lessons.dart';
import '../../services/lesson/lesson_services.dart';
import 'lesson_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final LessonsService service;

  LessonsCubit(this.service) : super(const LessonsState());

  Future<void> loadLessons() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final lessons = await service.getLessons();
      emit(state.copyWith(isLoading: false, lessons: lessons));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Dersler yüklenemedi.'));
    }
  }

  Future<void> addLesson(Lesson lesson) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final newLessonId = await service.addLesson(lesson);
      final lessonWithId = Lesson(
        id: newLessonId,
        name: lesson.name,
        lessonsSubject: lesson.lessonsSubject,
        examDate: lesson.examDate,
        difficulty: lesson.difficulty,
        completionStatus: lesson.completionStatus,
      );

      final updatedLessons = List<Lesson>.from(state.lessons)
        ..insert(0, lessonWithId);

      emit(state.copyWith(isLoading: false, lessons: updatedLessons));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Ders eklenemedi.'));
    }
  }

  Future<void> deleteLesson(String lessonId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await service.deleteLesson(lessonId);
      final lessons = await service.getLessons();
      emit(state.copyWith(isLoading: false, lessons: lessons));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Ders silinemedi.'));
    }
  }

  Future<void> updateLesson(String lessonId, Lesson lesson) async {
    debugPrint('Cubit updateLesson çağrıldı');
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await service.updateLesson(lessonId, lesson);
      debugPrint('Service updateLesson tamamlandı');
      final lessons = await service.getLessons();
      emit(state.copyWith(isLoading: false, lessons: lessons));
    } catch (e) {
      debugPrint('Cubit updateLesson hatası: $e');
      emit(state.copyWith(isLoading: false, error: 'Ders güncellenemedi.'));
    }
  }
}
