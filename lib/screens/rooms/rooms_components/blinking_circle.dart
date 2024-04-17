import 'package:flutter/material.dart';

class BlinkingCircle extends StatelessWidget {
  final AnimationController animationController;

  const BlinkingCircle({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: Container(
        width: 12.0,
        height: 12.0,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}