import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia/src/rust/api/error.dart';
import 'package:trivia/src/rust/api/session.dart';
import 'package:trivia/utils/common_widgets/input_field.dart';

import '../../consts.dart';
import '../../utils/dialogs/error_dialog.dart';

class PasswordRecoveryDialog extends StatefulWidget {
  const PasswordRecoveryDialog({super.key});

  @override
  State<PasswordRecoveryDialog> createState() => _PasswordRecoveryDialogState();
}

class _PasswordRecoveryDialogState extends State<PasswordRecoveryDialog> {
  TextEditingController emailController = TextEditingController();
  String? emailErrorText;
  bool isLoading = false;

  Future<void> sendEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final serverIp = prefs.getString(serverIpKey) ?? defaultServerIp;
    final serverPort = prefs.getString(serverPortKey) ?? defaultPort;
    setState(() {
      isLoading = true;
      emailErrorText = null;
    });
    try {
      await Session.forgotPassword(
          email: emailController.text, address: "$serverIp:$serverPort");
      if (!mounted || !context.mounted) return;
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                icon: const Icon(Icons.check_circle_outline_sharp,
                    size: 64, color: Colors.green),
                title: const Text(
                  'Password Recovery',
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'We have sent an email with your password.',
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
    } on Error_EmailDoesNotExist catch (e) {
      if (!mounted || !context.mounted) return;
      setState(() {
        emailErrorText = "• ${e.format()}";
      });
    } on Error catch (e) {
      if (!mounted || !context.mounted) return;
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => ErrorDialog(
                message: e.format(),
                title: "Failed To Recover Password",
              ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Password Recovery',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'We will send you an email with a link to reset your password.',
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: InputField(
              controller: emailController,
              errorText: emailErrorText,
              validate: (value) {
                setState(() {
                  emailErrorText = null;
                });
              },
              onFieldSubmitted: (value) {
                if (!mounted || !context.mounted) return;
                if (emailController.text.isEmpty || isLoading) return;
                sendEmail();
              },
              label: "Email",
              enabled: !isLoading,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: isLoading || emailController.text.isEmpty
              ? null
              : () {
                  sendEmail();
                },
          child: isLoading
              ? const CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                )
              : const Text("Confirm"),
        )
      ],
    );
  }
}
