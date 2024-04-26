import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trivia/utils/input_field.dart';
import 'consts.dart';
import 'providers/server_endpoint_provider.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController serverIpController;
  String? serverIpErrorText;
  late TextEditingController serverPortController;
  String? serverPortErrorText;

  @override
  void initState() {
    final serverEndpointProvider =
        Provider.of<ServerEndpointProvider>(context, listen: false);
    serverIpController =
        TextEditingController(text: serverEndpointProvider.serverIp);
    serverPortController =
        TextEditingController(text: serverEndpointProvider.port.toString());
    super.initState();
  }

  @override
  void dispose() {
    serverIpController.dispose();
    serverPortController.dispose();
    super.dispose();
  }

  void validateIP(String value) {
    if (value.isEmpty) {
      serverIpErrorText = null;
    } else {
      if (!RegExp(r"^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$")
          .hasMatch(value)) {
        serverIpErrorText = "• Invalid IP address\n• Example: 127.0.0.1";
      } else {
        serverIpErrorText = null;
      }
    }
  }

  void validatePort(String value) {
    if (value.isEmpty) {
      serverPortErrorText = null;
    } else {
      if (int.tryParse(value) == null) {
        serverPortErrorText = "• Invalid port";
      } else if (int.parse(value) < 0 || int.parse(value) > 65535) {
        serverPortErrorText = "• Port must be between 0 and 65535";
      } else {
        serverPortErrorText = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverEndpointProvider = Provider.of<ServerEndpointProvider>(context);
    return AlertDialog(
      title: const Text("Server Settings"),
      icon: const Icon(Icons.settings_sharp),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      actionsPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      actions: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilledButton(
                  onPressed: isAllFieldsValid()
                      ? () {
                          serverEndpointProvider
                              .setServerIp(serverIpController.text);
                          serverEndpointProvider
                              .setPort(int.parse(serverPortController.text));
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text(
                    "Save",
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ),
          ]),
        )
      ],
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // This ensures the column takes up only the necessary height
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputField(
                inputType: TextInputType.number,
                controller: serverIpController,
                errorText: serverIpErrorText,
                validate: (String value) {
                  setState(() {
                    validateIP(value);
                  });
                },
                label: "IP Address",
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        serverIpController.text = "127.0.0.1";
                        validateIP(serverIpController.text);
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputField(
                inputType: TextInputType.number,
                controller: serverPortController,
                errorText: serverPortErrorText,
                validate: (String value) {
                  setState(() {
                    validatePort(value);
                  });
                },
                label: "Port",
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: isAllFieldsValid()
                    ? TextInputAction.next
                    : TextInputAction.done,
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        serverPortController.text = defaultPort.toString();
                        validatePort(serverPortController.text);
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isAllFieldsValid() {
    return serverIpErrorText == null &&
        serverPortErrorText == null &&
        serverPortController.text.isNotEmpty &&
        serverIpController.text.isNotEmpty;
  }
}
