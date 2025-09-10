import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vena/features/calendar/logic/cubit/calendar_cubit.dart';
import 'package:vena/features/splash/presentation/pages/splash_screen.dart';
import 'package:vena/features/calendar/data/services/calendar_services.dart';
import 'package:vena/features/lesson/data/services/lesson_services.dart';
import 'features/auth/logic/cubit/auth_cubit.dart';
import 'features/lesson/logic/cubit/lesson_cubit.dart';
import 'features/auth/data/services/auth_services.dart';
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
