import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vena/model/calendar/study_plan.dart';
import 'package:vena/widget/calendar/calendar_header.dart';
import 'package:vena/widget/success_confetti_widget.dart';
import '../../cubit/calendar/calendar_cubit.dart';
import '../../cubit/calendar/calendar_state.dart';
import '../../cubit/lesson/lesson_cubit.dart';
import '../../themes/app_colors.dart';
import 'package:vena/utils/date.dart';
import 'package:vena/utils/size.dart';
import '../../widget/calendar/ai_genarating_text.dart';
import '../../widget/calendar/confirm_new_plan_dialog.dart';
import '../../widget/calendar/loading_info_box.dart';
import '../../widget/calendar/session_card.dart';
import '../../widget/calendar/stat_box.dart';
import 'package:confetti/confetti.dart';
import '../../widget/plan_settings_dialog.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late ConfettiController _controllerCenterLeft;
  late ConfettiController _controllerCenterRight;

  @override
  void initState() {
    super.initState();
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 1));
    Future.microtask(() {
      context.read<CalendarCubit>().fetchPlansFromBackend();
    });
  }

  @override
  void dispose() {
    _controllerCenterLeft.dispose();
    _controllerCenterRight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonsState = context.watch<LessonsCubit>().state;
    final calendarCubit = context.read<CalendarCubit>();
    final calendarState = context.watch<CalendarCubit>().state;

    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SuccessConfettiWidget(
                controller: _controllerCenterRight,
                alignment: Alignment.centerRight),
            SuccessConfettiWidget(
                controller: _controllerCenterLeft,
                alignment: Alignment.centerLeft),
            SuccessConfettiWidget(
                controller: _controllerCenterLeft,
                alignment: Alignment.centerLeft),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenSize.getSize(context).height * 0.04),
                  // icon text and refresh button
                  CalendarHeader(
                    onRefreshPressed: () async {
                      if (lessonsState.lessons.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Lütfen önce dersleri ekleyin.")),
                        );
                        return;
                      }

                      final settings = await showDialog<Map<String, dynamic>>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const PlanSettingsDialog(
                          initialStartTime: TimeOfDay(hour: 9, minute: 0),
                          initialEndTime: TimeOfDay(hour: 20, minute: 0),
                          initialBreakMinutes: 30,
                        ),
                      );

                      if (settings == null) {
                        return;
                      }

                      final startTime = settings['startTime'] as TimeOfDay;
                      final endTime = settings['endTime'] as TimeOfDay;
                      final breakMinutes = settings['breakMinutes'] as int;

                      String formatTimeOfDay(TimeOfDay t) =>
                          t.hour.toString().padLeft(2, '0') +
                          ":" +
                          t.minute.toString().padLeft(2, '0');

                      Future<void> generate() async {
                        final requestBody = calendarCubit.createRequestBody(
                          lessons: lessonsState.lessons,
                          startingTime: formatTimeOfDay(startTime),
                          endTime: formatTimeOfDay(endTime),
                          breakTimeMinutes: breakMinutes,
                        );

                        await calendarCubit.generateCalendar(requestBody);
                        _controllerCenterRight.play();
                        _controllerCenterLeft.play();
                      }

                      if (calendarState.plans.isNotEmpty) {
                        final bool? result = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => const ConfirmNewPlanDialog(),
                        );

                        if (result == true) {
                          await generate();
                        }
                      } else {
                        await generate();
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                  BlocBuilder<CalendarCubit, CalendarState>(
                    builder: (context, state) {
                      final hasPlans = state.plans.isNotEmpty;

                      if (state.isLoading && !hasPlans) {
                        return const LoadingInfoBox(
                          message: "",
                          trailing: AiGeneratingText(),
                        );
                      }

                      if (state.error != null) {
                        return Center(child: Text("Hata: ${state.error}"));
                      }

                      final totalSessions = state.plans.fold<int>(
                        0,
                        (prev, plan) => prev + plan.sessions.length,
                      );

                      final topWidget = state.isGenerating
                          ? const LoadingInfoBox(
                              message: "",
                              trailing: AiGeneratingText(
                                message: "AI yeni program oluşturuyor",
                                textColor: AppColors.aiWaitingTextColor,
                                fontSize: 15,
                              ),
                            )
                          : const SizedBox.shrink();

                      return Column(
                        children: [
                          topWidget,
                          const SizedBox(height: 10),
                          // plan içeriği haftalık kaç saat, seans olacağı ve ai güven skoru
                          _buildPlanInfo(context, state, totalSessions),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<CalendarCubit, CalendarState>(
                builder: (context, state) {
                  if (!state.isRefreshing && state.plans.isEmpty) {
                    return const Center(
                      child: Text("Henüz takvim oluşturulmadı.",
                          style: TextStyle(fontSize: 18)),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.plans.length,
                    itemBuilder: (context, index) {
                      final plan = state.plans[index];
                      final dailyDurationStr =
                          "${plan.dailyTotalHours.toStringAsFixed(1)} saat";

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // tarih gün ve günde kaç saat çalışacağı bilgisi
                            _buildDateAndHourDetails(plan, dailyDurationStr),
                            const SizedBox(height: 8),
                            ...plan.sessions.map((session) => SessionCard(
                                  session: session,
                                  onTap: () {
                                    calendarCubit.toggleSessionCompletion(
                                        plan.date, session.id);
                                  },
                                )),
                            const Divider(thickness: 1.2),
                          ],
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

  Row _buildPlanInfo(
      BuildContext context, CalendarState state, int totalSessions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatBox(
          context: context,
          value:
              "${state.meta?.weeklyTotalHours.toStringAsFixed(1) ?? '0.0'} saat",
          label: "Bu hafta toplam",
        ),
        SizedBox(width: ScreenSize.getSize(context).width * 0.03),
        StatBox(
          context: context,
          value: "$totalSessions",
          label: "Çalışma seansı",
        ),
        SizedBox(width: ScreenSize.getSize(context).width * 0.03),
        StatBox(
          context: context,
          value:
              "%${((state.meta?.aiConfidence ?? 0.0) * 100).toStringAsFixed(0)}",
          label: "AI güven skoru",
        ),
      ],
    );
  }

  Row _buildDateAndHourDetails(StudyPlan plan, String dailyDurationStr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.day,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              Date.formatDate(plan.date),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset("assets/time-icon.png"),
            const SizedBox(width: 4),
            Text(
              dailyDurationStr,
              style: const TextStyle(color: AppColors.timeTextColor),
            ),
          ],
        ),
      ],
    );
  }
}
