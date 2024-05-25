import 'package:flutter/material.dart';

class AnimatedGradientText extends StatefulWidget {
  const AnimatedGradientText(this.text,{
    super.key,
    required this.colors,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final List<Color> colors;

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward()..addListener((){if (_controller.isCompleted)_controller.repeat();});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GradientText(
          widget.text,
          colors: widget.colors,
          style: widget.style,
          slideRatio: _controller.value,
        );
      },
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        super.key,
        required this.colors,
        this.style,
        this.slideRatio,
      });

  final String text;
  final TextStyle? style;
  final List<Color> colors;
  final double? slideRatio;

  @override
  Widget build(BuildContext context) {
    final colors = [...this.colors, this.colors[0]];
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        tileMode: TileMode.repeated,
        transform: SlideGradient(slideRatio ?? 0),
        colors: colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}

class SlideGradient extends GradientTransform {

  final double slideRatio;
  const SlideGradient(this.slideRatio);
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final dist = slideRatio * bounds.width;
    return Matrix4.identity()..translate(-dist);
  }
}