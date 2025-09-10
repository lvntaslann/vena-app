import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class DifficultyColors {
  static const Map<String, Color> containerColors = {
    'Kolay': AppColors.easyContainerColor,
    'Orta': AppColors.mediumContainerColor,
    'Zor': AppColors.hardContainerColor,
  };

  static const Map<String, Color> textColors = {
    'Kolay': AppColors.easyContainerTextColor,
    'Orta': AppColors.mediumContainerTextColor,
    'Zor': AppColors.hardContainerTextColor,
  };

  static Color getContainerColor(String difficulty) {
    return containerColors[difficulty] ?? Colors.grey;
  }

  static Color getTextColor(String difficulty) {
    return textColors[difficulty] ?? Colors.grey;
  }
}
