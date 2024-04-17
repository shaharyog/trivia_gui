import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils.dart';
import '../utils/toggle_theme_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String username = '';
  String password = '';
  String email = '';
  String address = '';
  String phoneNumber = '';
  String birthDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: themeToggleButton(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign up",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Create an account, It's free",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputField(
                    label: "User Name",
                    moveFocusToNext: true,
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputField(
                    label: "Password",
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: true,
                    moveFocusToNext: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputField(
                    label: "Email",
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    moveFocusToNext: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputField(
                    label: "Address",
                    onChanged: (value) {
                      setState(() {
                        address = value;
                      });
                    },
                    moveFocusToNext: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputField(
                    label: "Phone Number",
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                    moveFocusToNext: true,
                    isNumberField: true,
                    formatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                      PhoneNumberFormatter()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputField(
                    label: "Birthday",
                    onChanged: (value) {
                      setState(() {
                        birthDate = value;
                      });
                    },
                    moveFocusToNext: true,
                    isNumberField: true,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(200, 60),
                  ),
                  onPressed: !isAllFieldsEntered()
                      ? null
                      : () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                  child: const Text(
                    "Sign up",
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              "Sign in",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isAllFieldsEntered() {
    return username.isNotEmpty &&
        password.isNotEmpty &&
        email.isNotEmpty &&
        address.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        birthDate.isNotEmpty;
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final sanitizedValue = newValue.text
        .replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric characters
    var newText = '';

    for (var i = 0; i < sanitizedValue.length; i++) {
      if (i == 3) {
        newText += '-';
      }
      newText += sanitizedValue[i];
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
