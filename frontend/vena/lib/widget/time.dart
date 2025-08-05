import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/time-icon.png"),
          const Text(
            "42 saat toplam",
            style: TextStyle(
                fontSize: 16, color: AppColors.dailyContainerThirdTextColor),
          ),
        ],
      ),
    );
  }
}