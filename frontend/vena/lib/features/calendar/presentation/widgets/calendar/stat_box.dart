import 'package:flutter/material.dart';
import 'package:vena/core/utils/size.dart';
import 'package:vena/core/themes/app_colors.dart';

class StatBox extends StatelessWidget {
  final String value;
  final String label;
  final BuildContext context;
  const StatBox({super.key, required this.value, required this.label, required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.getSize(context).width * 0.28,
      height: ScreenSize.getSize(context).height * 0.13,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.miniContainerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
