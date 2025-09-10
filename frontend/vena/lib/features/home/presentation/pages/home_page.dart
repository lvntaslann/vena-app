import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vena/features/auth/logic/cubit/auth_cubit.dart';
import 'package:vena/features/auth/logic/cubit/auth_state.dart';
import 'package:vena/features/calendar/data/model/study_session.dart';
import 'package:vena/features/calendar/presentation/pages/calendar_page.dart';
import 'package:vena/core/themes/app_colors.dart';
import 'package:vena/core/utils/size.dart';
import 'package:vena/core/widgets/container/state_container.dart';
import '../../../../core/constants/difficulty_item.dart';
import '../../../calendar/logic/cubit/calendar_cubit.dart';
import '../../../calendar/logic/cubit/calendar_state.dart';
import '../../../lesson/logic/cubit/lesson_cubit.dart';
import '../../../lesson/data/model/lessons.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final todayStr = "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";

    Future.microtask(() {
      context.read<CalendarCubit>().fetchDailyPlan(todayStr);
      context.read<LessonsCubit>().loadLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessonsState = context.watch<LessonsCubit>().state;
    final userState = context.watch<AuthCubit>().state;
    final lessonList = lessonsState.lessons;

    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _welcomeText(userState),
                SizedBox(height: ScreenSize.getSize(context).height * 0.001),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    "Bugün harika bir çalışma günü",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: ScreenSize.getSize(context).height * 0.03),
                BlocBuilder<CalendarCubit, CalendarState>(
                  builder: (context, calendarState) {
                    final weeklyCompletionRate =
                        calendarState.weeklyCompletionRate ?? 0.0;
                    final focusScore = calendarState.focusScore ?? 0.0;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _weeklyCompletionRate(context, weeklyCompletionRate),
                        _focusScore(context, focusScore),
                      ],
                    );
                  },
                ),
                SizedBox(height: ScreenSize.getSize(context).height * 0.03),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                    height: ScreenSize.getSize(context).height * 0.20,
                    width: ScreenSize.getSize(context).width * 0.9,
                    decoration: BoxDecoration(
                      color: AppColors.aiContanierColor,
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(
                        left: BorderSide(
                          color: AppColors.aiContainerStrokeColor,
                          width: 8,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _aiSuggestion(),
                        const Padding(
                          padding: EdgeInsets.only(left: 65),
                          child: Text(
                            "Başarılı olmak için\nçalışma takvimine uymalısın",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _seeDetailsButton(context),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.getSize(context).height * 0.03),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      Image.asset("assets/calendar-icon.png"),
                      const SizedBox(width: 10),
                      const Text(
                        "Bugünün çalışma planı",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenSize.getSize(context).height * 0.02),
                BlocBuilder<CalendarCubit, CalendarState>(
                  builder: (context, calendarState) {
                    final dailyPlan = calendarState.dailyPlan;

                    if (dailyPlan != null && dailyPlan.sessions.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dailyPlan.sessions.length,
                          itemBuilder: (context, index) {
                            final session = dailyPlan.sessions[index];
                            final lesson = lessonList.firstWhere(
                              (l) => l.name == session.lessons,
                              orElse: () => Lesson(
                                id: "",
                                name: session.lessons,
                                lessonsSubject: [],
                                difficulty: "Kolay",
                                examDate: DateTime.now(),
                                completionStatus: false,
                              ),
                            );

                            final difficulty = lesson.difficulty;
                            final containerColor =
                                DifficultyColors.getContainerColor(difficulty);
                            final textColor =
                                DifficultyColors.getTextColor(difficulty);
                            final diffcultyText = difficulty;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                              decoration: BoxDecoration(
                                color: AppColors.miniContainerColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _lessonsDetails(session),
                                  const SizedBox(width: 12),
                                  _completionStatus(
                                      containerColor,
                                      diffcultyText,
                                      textColor,
                                      context,
                                      session),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.only(left: 50),
                        child:
                            Text("Bugün için çalışma planı bulunmamaktadır."),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _aiSuggestion() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 20),
      child: Row(
        children: [
          Image.asset("assets/ai-icon.png"),
          const SizedBox(width: 15),
          const Text(
            "AI önerisi",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Padding _welcomeText(AuthState userState) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Merhaba, ${userState.name}!",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Image.asset("assets/punch-icon.png"),
        ],
      ),
    );
  }

  Column _completionStatus(Color containerColor, String diffcultyText,
      Color textColor, BuildContext context, StudySession session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StateContainer(
          containerColor: containerColor,
          containerText: diffcultyText,
          containerTextcolor: textColor,
        ),
        SizedBox(height: ScreenSize.getSize(context).height * 0.01),
        StateContainer(
          containerColor: session.isCompleted
              ? AppColors.dailyPlanSuccsessContainerColors
              : AppColors.dailyPlanWaitingContainerColors,
          containerText: session.isCompleted ? "Yapıldı" : "Bekliyor",
          containerTextcolor: session.isCompleted
              ? AppColors.dailyPlanSuccsessTextColors
              : AppColors.dailyPlanWaitingTextColors,
        ),
      ],
    );
  }

  Expanded _lessonsDetails(StudySession session) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.lessons,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.dailyContainerFirstTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${session.startingTime} - ${session.endTime}",
            style: const TextStyle(
              fontSize: 17,
              color: AppColors.dailyContainerSecondTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            session.lessonsSubject,
            style: const TextStyle(
              fontSize: 17,
              color: AppColors.dailyContainerSecondTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset(
                "assets/time-icon.png",
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 6),
              Text(
                "${session.lessonsDuration.toStringAsFixed(1)} saat",
                style: const TextStyle(
                  fontSize: 17,
                  color: AppColors.dailyContainerThirdTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding _seeDetailsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 65),
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CalendarPage())),
        child: Container(
          height: ScreenSize.getSize(context).height * 0.04,
          width: ScreenSize.getSize(context).width * 0.25,
          decoration: BoxDecoration(
            color: AppColors.buttonBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              "Detayları gör",
              style: TextStyle(
                color: AppColors.buttonTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _focusScore(BuildContext context, double focusScore) {
    return Container(
      height: ScreenSize.getSize(context).height * 0.18,
      width: ScreenSize.getSize(context).width * 0.4,
      decoration: BoxDecoration(
        color: AppColors.miniContainerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/dart-icon.png"),
          Text(
            focusScore.toStringAsFixed(0),
            style: const TextStyle(
              color: AppColors.appNumberColor,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text("Odaklanma skoru"),
        ],
      ),
    );
  }

  Container _weeklyCompletionRate(
      BuildContext context, double weeklyCompletionRate) {
    return Container(
      height: ScreenSize.getSize(context).height * 0.18,
      width: ScreenSize.getSize(context).width * 0.4,
      decoration: BoxDecoration(
        color: AppColors.miniContainerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/brain-icon.png"),
          Text(
            "%${(weeklyCompletionRate * 100).toStringAsFixed(0)}",
            style: const TextStyle(
              color: AppColors.appNumberColor,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text("Haftalık hedef"),
        ],
      ),
    );
  }
}
