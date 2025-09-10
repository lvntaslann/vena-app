import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../../utils/size.dart';

class AuthTextField extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    required this.icon,
    required this.labelText,
    this.obscureText = false,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.getSize(context).height * 0.06,
      width: ScreenSize.getSize(context).width * 0.7,
      decoration: BoxDecoration(
        color: AppColors.authPageTextFieldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextField(
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
              color: AppColors.authPageLabelTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(icon, color: AppColors.authPageTextFieldIconColor),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
