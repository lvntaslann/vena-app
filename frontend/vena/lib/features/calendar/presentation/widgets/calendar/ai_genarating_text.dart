import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AiGeneratingText extends StatelessWidget {
  final String message;
  final Color? textColor;
  final double? fontSize;

  const AiGeneratingText({
    super.key,
    this.message = "Ders planın AI tarafından oluşturuluyor",
    this.textColor = Colors.black87,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(width: 6),
        DefaultTextStyle(
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              TyperAnimatedText('...', speed:const Duration(milliseconds: 500)),
            ],
          ),
        ),
      ],
    );
  }
}
