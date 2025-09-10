import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class SuccessConfettiWidget extends StatelessWidget {
  const SuccessConfettiWidget({
    super.key,
    required ConfettiController controller,
    required this.alignment,
  }) : _controller = controller;

  final ConfettiController _controller;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
            blastDirectionality: BlastDirectionality.explosive,
            confettiController: _controller,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            gravity: 0.05,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.red,
              Colors.yellow,
              Colors.blue,
            ],
          ),
    );
  }
}
