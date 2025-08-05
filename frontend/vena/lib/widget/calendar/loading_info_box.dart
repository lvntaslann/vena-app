import 'package:flutter/material.dart';
import 'package:vena/themes/app_colors.dart';

class LoadingInfoBox extends StatelessWidget {
  final String message;
  final Widget? trailing;

  const LoadingInfoBox({super.key, required this.message, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.aiWaitingContainerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          trailing ??
              const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
