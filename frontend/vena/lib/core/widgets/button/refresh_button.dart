import 'package:flutter/material.dart';

import '../../utils/size.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: Container(
          height: ScreenSize.getSize(context).height * 0.04,
          width: ScreenSize.getSize(context).width * 0.08,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child:  Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}