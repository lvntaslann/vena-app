import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
   return ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
  ),
  child: BottomAppBar(
    color: Colors.white, // veya başka renk
    elevation: 10,
    child: SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, 'assets/home-active.png', 'assets/home-pasive.png', "Anasayfa"),
          _buildNavItem(1, 'assets/lessons-active.png', 'assets/lessons-pasive.png', "Derslerim"),
          _buildNavItem(2, 'assets/calendar-active.png', 'assets/calendar-pasive.png', "Takvim"),
          _buildNavItem(3, 'assets/settings-active.png', 'assets/settings-pasive.png', "Ayarlar"),
        ],
      ),
    ),
  ),
);
  }

  Widget _buildNavItem(int index, String activeIcon, String inactiveIcon, String label) {
    bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isActive ? activeIcon : inactiveIcon,
            width: 25,
            height: 25,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.navbarTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
