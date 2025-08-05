import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../themes/app_colors.dart';
import '../widget/bottom_navbar.dart';
import 'calendarpage/calendar_page.dart';
import 'home/home_page.dart';
import 'lessonspage/lessons_page.dart';
import 'settings/settings.dart';

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
