import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vena/cubit/calendar/calendar_cubit.dart';
import 'package:vena/pages/splash/splash_screen.dart';
import 'package:vena/services/calendar/calendar_services.dart';
import 'package:vena/services/lesson/lesson_services.dart';
import 'cubit/auth/auth_cubit.dart';
import 'cubit/lesson/lesson_cubit.dart';
import 'services/auth/auth_services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthServices())),
        BlocProvider(
          create: (_) => LessonsCubit(LessonsService())..loadLessons(),
        ),
        BlocProvider(create: (_) => CalendarCubit(CalendarService())),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:  [
        Locale('tr', 'TR'),
      ],
      locale:  Locale('tr', 'TR'),
    );
  }
}
