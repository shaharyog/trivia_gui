import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;

  const ErrorDialog({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final FocusNode dismissButtonFocs = FocusNode();
    dismissButtonFocs.requestFocus();
    return AlertDialog(
      icon: const Icon(
        Icons.warning_amber,
        color: Colors.redAccent,
        size: 64,
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        TextButton(
          focusNode: dismissButtonFocs,
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
