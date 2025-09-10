import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vena/core/themes/app_colors.dart';
import 'package:vena/core/widgets/bottom_navbar.dart';
import 'package:vena/features/calendar/presentation/pages/calendar_page.dart';
import 'package:vena/features/home/presentation/pages/home_page.dart';
import 'package:vena/features/lesson/presentation/pages/lessons_page.dart';
import 'package:vena/features/settings/presentation/pages/settings.dart';


class MyPageController extends StatefulWidget {
  const MyPageController({Key? key}) : super(key: key);

  @override
  _MyPageControllerState createState() => _MyPageControllerState();
}

class _MyPageControllerState extends State<MyPageController> {
  int currentIndex = 0;

  List<Widget> getPages() {
    return [
      const Homepage(),
      const LessonsPage(),
      const CalendarPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: getPages()[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
