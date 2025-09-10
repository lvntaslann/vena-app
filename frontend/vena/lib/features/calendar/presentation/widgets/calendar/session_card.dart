import 'package:flutter/material.dart';
import 'package:vena/features/calendar/data/model/study_session.dart';
import 'package:vena/core/themes/app_colors.dart';

class SessionCard extends StatelessWidget {
  final StudySession session;
  final Function() onTap;

  const SessionCard({super.key, required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: AppColors.miniContainerColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${session.startingTime} - ${session.endTime}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.timeTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    session.lessons,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lessonNameColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.lessonsSubject,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.lessonsSubjectColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: session.isCompleted ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: session.isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
