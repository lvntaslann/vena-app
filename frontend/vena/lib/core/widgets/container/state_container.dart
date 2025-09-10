import 'package:flutter/widgets.dart';
import 'package:vena/core/utils/size.dart';

class StateContainer extends StatelessWidget {
  const StateContainer({
    required this.containerColor,
    required this.containerText,
    required this.containerTextcolor,
    super.key,
  });

  final Color containerColor;
  final String containerText;
  final Color containerTextcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.getSize(context).width*0.20,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        containerText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: containerTextcolor,
          fontSize: 13,
        ),
      ),
    );
  }
}
