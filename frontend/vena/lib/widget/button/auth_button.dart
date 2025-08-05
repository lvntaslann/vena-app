import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../../utils/size.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    required this.onTap,
    required this.buttonText,
    super.key,
  });
  final String buttonText;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: ScreenSize.getSize(context).height * 0.07,
        width: ScreenSize.getSize(context).width * 0.6,
        decoration: BoxDecoration(
          color: AppColors.authButtonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child:  Center(
          child: Text(
            buttonText,
            style: const TextStyle(
                color: AppColors.buttonTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
      ),
    );
  }
}