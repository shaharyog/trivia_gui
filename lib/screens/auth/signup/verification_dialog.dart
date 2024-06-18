import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trivia/consts.dart';
import 'package:trivia/homepage/homepage.dart';
import 'package:trivia/src/rust/api/error.dart';
import 'package:trivia/utils/common_widgets/input_field.dart';
import '../../../src/rust/api/session.dart';
import '../../../utils/common_functionalities/window_management.dart';
import '../../../utils/dialogs/error_dialog.dart';

class SignupVerificationDialog extends StatefulWidget {
  final Session session;
  final String username;
  final String email;

  const SignupVerificationDialog({
    super.key,
    required this.session,
    required this.username,
    required this.email,
  });

  @override
  State<SignupVerificationDialog> createState() =>
      _SignupVerificationDialogState();
}

class _SignupVerificationDialogState extends State<SignupVerificationDialog> {
  bool _isLoading = false;
  TextEditingController codeController = TextEditingController();
  String? codeErrorText;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> submitVerificationCode() async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool isVerified = await widget.session
          .submitVerificationCode(code: codeController.text);
      if (!mounted || !context.mounted) return;
      if (!isVerified) {
        setState(() {
          codeErrorText = "• Incorrect verification code";
        });
        return;
      }
      setWindowTitle("Trivia - @${widget.username}");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage(session: widget.session, username: widget.username);
          },
        ),
      );
    } on Error_ServerConnectionError catch (serverConnError) {
      if (!mounted || !context.mounted) return;
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          title: serverConnErrorText,
          message: serverConnError.format(),
        ),
      );
    } on Error_VerificationCodeTooManyAttempts catch (error) {
      if (!mounted || !context.mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          title: "Verification error",
          message: error.format(),
        ),
      );
    } on Error catch (error) {
      if (!mounted || !context.mounted) return;
      setState(() {
        codeErrorText = "• ${error.format()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> resendVerificationCode() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.session.resendVerificationCode();
    } on Error_ServerConnectionError catch (serverConnError) {
      if (!mounted || !context.mounted) return;
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          title: serverConnErrorText,
          message: serverConnError.format(),
        ),
      );
    } on Error catch (error) {
      if (!mounted || !context.mounted) return;
      setState(() {
        codeErrorText = "• ${error.format()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.email_outlined,
        size: 48.0,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Email Verification'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              text: "Enter verification code sent to ",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
              children: [
                TextSpan(
                  text: widget.email,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: InputField(
              enabled: !_isLoading,
              controller: codeController,
              errorText: codeErrorText,
              inputType: TextInputType.number,
              validate: (String value) {
                setState(
                  () {
                    if (value.isEmpty) {
                      codeErrorText = null;
                    }
                    if (!value.contains(RegExp(r'^[0-9]{6}$'))) {
                      codeErrorText =
                          "• Invalid verification code, should be 6 digits";
                    } else {
                      codeErrorText = null;
                    }
                  },
                );
              },
              label: "Verification Code",
            ),
          ),
          GestureDetector(
            onTap: !_isLoading
                ? () {
                    codeErrorText = null;
                    resendVerificationCode();
                  }
                : null,
            child: MouseRegion(
              cursor: !_isLoading
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              child: Text(
                "Resend code",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: !_isLoading
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).disabledColor,
                    ),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: !_isLoading
              ? () {
                  widget.session.dispose();
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed:
              !_isLoading && codeController.text.contains(RegExp(r'^[0-9]{6}$'))
                  ? () {
                      submitVerificationCode();
                    }
                  : null,
          child: const Text('Verify'),
        ),
      ],
    );
  }
}
