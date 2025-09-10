import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/widgets/button/refresh_button.dart';

class CalendarHeader extends StatelessWidget {
  final VoidCallback onRefreshPressed;

  const CalendarHeader({
    super.key,
    required this.onRefreshPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/ai-icon-2.png', height: 40, width: 40),
        const SizedBox(width: 10),
        const Text(
          "AI Çalışma Takvimi",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        RefreshButton(
          icon: Icons.refresh,
          iconColor: AppColors.refreshIconColor,
          backgroundColor: Colors.grey[200]!,
          onTap: onRefreshPressed,
        ),
      ],
    );
  }
}
