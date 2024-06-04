import 'package:flutter/material.dart';
import '../../src/rust/api/request/get_question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final bool isSmallScreen;
  const QuestionWidget(
      {super.key, required this.question, required this.isSmallScreen});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.isSmallScreen ? double.infinity : MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        )
      ),
      child: Text(
        widget.question.question,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
