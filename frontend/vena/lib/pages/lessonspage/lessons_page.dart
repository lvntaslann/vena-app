import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../constants/difficulty_item.dart';
import '../../cubit/calendar/calendar_cubit.dart';
import '../../cubit/calendar/calendar_state.dart';
import '../../cubit/lesson/lesson_cubit.dart';
import '../../cubit/lesson/lesson_state.dart';
import '../../themes/app_colors.dart';
import '../../widget/add_lesson_bottomsheet.dart';
import 'package:vena/model/lesson/lessons.dart';
import '../../widget/resources_dialog.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarCubit = context.read<CalendarCubit>();
    final lessonsState = context.watch<LessonsCubit>().state;
    final scaffoldContext = context;
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Derslerim",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final requestBody = calendarCubit.createRequestBody(
                              lessons: lessonsState.lessons,
                              startingTime: "09:00",
                              endTime: "18:00",
                              breakTimeMinutes: 30,
                            );

                            try {
                              final resources = await calendarCubit
                                  .fetchResources(requestBody);
                              showDialog(
                                context: context,
                                builder: (_) =>
                                    ResourceDialog(resources: resources),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Kaynaklar alınamadı: $e")),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFD0E9FF),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            "AI'dan kaynak önerisi al!",
                            style: TextStyle(
                              color: Color(0xFF228BE6),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: Colors.blue, size: 28),
                    onPressed: () async {
                      final newLesson =
                          await showAddLessonBottomSheet(scaffoldContext);
                      if (newLesson != null && scaffoldContext.mounted) {
                        scaffoldContext
                            .read<LessonsCubit>()
                            .addLesson(newLesson);
                      }
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<CalendarCubit, CalendarState>(
              builder: (context, state) {
                if (state.isGeneratingResources) {
                  return _buildLoadingContainer();
                }
                return const SizedBox.shrink();
              },
            ),
            // İçerik
            Expanded(
              child: BlocBuilder<LessonsCubit, LessonsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.error != null) {
                    return Center(child: Text(state.error!));
                  } else if (state.lessons.isEmpty) {
                    return const Center(child: Text("Henüz ders eklenmedi."));
                  }

                  final lessons = state.lessons;

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      final formattedDate =
                          DateFormat('dd MMM').format(lesson.examDate);

                      final difficultyColor =
                          DifficultyColors.getContainerColor(lesson.difficulty);
                      final difficultyTextColor =
                          DifficultyColors.getTextColor(lesson.difficulty);

                      return Slidable(
                        key: ValueKey(lesson.id),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            _slidableEdit(lesson, scaffoldContext),
                            _slidableDelete(lesson, scaffoldContext),
                          ],
                        ),
                        child: Card(
                          color: AppColors.miniContainerColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _lessonsDetails(lesson, difficultyColor,
                                    difficultyTextColor),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Sınav: $formattedDate"),
                                    // _waitingContainer()
                                  ],
                                ),
                                const SizedBox(height: 6),
                                _lessonSubject(lesson)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildLoadingContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFDFF1FF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF228BE6)),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "AI kaynak önerisi hazırlanıyor...",
                style: TextStyle(
                  color: Color(0xFF228BE6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Wrap _lessonSubject(Lesson lesson) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: lesson.lessonsSubject
          .map((topic) => Chip(
                label: Text(
                  topic,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 55, 55, 55),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColors.pageBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ))
          .toList(),
    );
  }

  Container _waitingContainer() {
    return Container(
      width: 65,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lessonsWaitingContainerColors,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const Text(
        "Bekliyor",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.lessonsWaitingTextColors,
        ),
      ),
    );
  }

  Row _lessonsDetails(
      Lesson lesson, Color difficultyColor, Color difficultyTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lesson.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          width: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: difficultyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            lesson.difficulty,
            style: TextStyle(
              fontSize: 12,
              color: difficultyTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  SlidableAction _slidableDelete(Lesson lesson, BuildContext scaffoldContext) {
    return SlidableAction(
      onPressed: (_) async {
        if (lesson.id != null) {
          await scaffoldContext.read<LessonsCubit>().deleteLesson(lesson.id!);
        }
      },
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'Sil',
    );
  }

  SlidableAction _slidableEdit(Lesson lesson, BuildContext scaffoldContext) {
    return SlidableAction(
      onPressed: (_) async {
        print('Düzenle butonuna basıldı');
        print(lesson.id);

        final updatedLesson = await showAddLessonBottomSheet(
          scaffoldContext,
          existingLesson: lesson,
        );

        print(
            'showAddLessonBottomSheet tamamlandı, güncellenen ders: $updatedLesson');

        if (updatedLesson != null && scaffoldContext.mounted) {
          final lessonWithId = updatedLesson.copyWith(id: lesson.id);
          await scaffoldContext
              .read<LessonsCubit>()
              .updateLesson(lesson.id!, lessonWithId);
        }
      },
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: 'Düzenle',
    );
  }
}
