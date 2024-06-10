import 'package:flutter/material.dart';

class BlinkingCircle extends StatelessWidget {
  final Color color;
  final AnimationController animationController;

  const BlinkingCircle({super.key, required this.animationController, required this.color});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: Container(
        width: 12.0,
        height: 12.0,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
