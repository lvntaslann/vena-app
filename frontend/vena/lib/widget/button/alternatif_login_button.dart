import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../../utils/size.dart';

class AlternatifLoginButton extends StatelessWidget {
  const AlternatifLoginButton({
    required this.onTap,
    super.key,
  });
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: ScreenSize.getSize(context).height * 0.065,
        width: ScreenSize.getSize(context).width * 0.65,
        decoration: BoxDecoration(
            color: AppColors.alternatifLoginContainerColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.alternatifLoginBorderColor,
              width: 1.5,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/google.png"),
            SizedBox(width: ScreenSize.getSize(context).width * 0.03),
            const Center(
              child: Text(
                "Google ile giriş yap",
                style: TextStyle(
                    color: AppColors.alternatifLoginTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
