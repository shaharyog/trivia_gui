import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../consts.dart';
import '../../providers/session_provider.dart';
import '../../utils/input_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernameController =
      TextEditingController(text: "yuval bar");
  String? usernameErrorText;
  TextEditingController passwordController = TextEditingController();
  String? passwordErrorText;
  bool _showPassword = false;
  TextEditingController emailController = TextEditingController();
  String? emailErrorText;
  TextEditingController addressController = TextEditingController();
  String? addressErrorText;
  TextEditingController phoneNumberController = TextEditingController();
  String? phoneNumberErrorText;
  TextEditingController birthdateController =
      TextEditingController(text: "00/00/2007");

  bool _isLoading = false;
  String? _errorText;

  void validateUsername(String value) {
    if (value.isEmpty) {
      usernameErrorText = null;
    } else if (value.length < 4) {
      usernameErrorText = "• Username must be at least 4 characters long";
    } else {
      usernameErrorText = null;
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordErrorText = null;
    } else if (!isValidPassword(value)) {
      bool isPasswordTooShort = value.length < 8;
      bool doesPasswordContainUppercase = value.contains(RegExp(r'[A-Z]'));
      bool doesPasswordContainLowercase = value.contains(RegExp(r'[a-z]'));
      bool doesPasswordContainNumber = value.contains(RegExp(r'[0-9]'));
      bool doesPasswordContainSpecialCharacter =
          value.contains(RegExp(r'[*&^%$#@!]'));

      String tempErrorText = "";
      if (isPasswordTooShort) {
        tempErrorText += "• Password must be at least 8 characters long\n";
      }
      if (!doesPasswordContainUppercase) {
        tempErrorText +=
            "• Password must contain at least one uppercase letter\n";
      }
      if (!doesPasswordContainLowercase) {
        tempErrorText +=
            "• Password must contain at least one lowercase letter\n";
      }
      if (!doesPasswordContainNumber) {
        tempErrorText += "• Password must contain at least one number\n";
      }
      if (!doesPasswordContainSpecialCharacter) {
        tempErrorText +=
            "• Password must contain at least one special character\n";
      }
      if (tempErrorText.isNotEmpty) {
        tempErrorText = tempErrorText.substring(0, tempErrorText.length - 1);
      }
      passwordErrorText = tempErrorText;
    } else {
      passwordErrorText = null;
    }
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailErrorText = null;
    } else if (!isValidEmail(value)) {
      emailErrorText = "• Invalid email address";
    } else {
      emailErrorText = null;
    }
  }

  void validateAddress(String value) {
    if (value.isEmpty) {
      addressErrorText = null;
    } else if (!isValidAddress(value)) {
      addressErrorText =
          "• Invalid address, format should be: 'Street, Number, City'\n• Street and City must contain only letters";
    } else {
      addressErrorText = null;
    }
  }

  void validatePhoneNumber(String value) {
    if (value.isEmpty) {
      phoneNumberErrorText = null;
    } else if (!isValidPhoneNumber(value)) {
      phoneNumberErrorText =
          "• Phone number must be a valid Israeli phone number";
    } else {
      phoneNumberErrorText = null;
    }
  }

  Future<void> _signup() async {
    setState(() {
      _errorText = null;
      _isLoading = true;
    });
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    // do nothing
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Text(getInitials(usernameController.text),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.white,
                        )),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                usernameController.text,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "member since: 00/00/2007",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InputField(
                  enabled: !_isLoading,
                  label: "Password",
                  inputType: TextInputType.visiblePassword,
                  controller: passwordController,
                  errorText: passwordErrorText,
                  showPassword: _showPassword,
                  isPassword: true,
                  validate: (String value) {
                    setState(() {
                      _errorText = null;
                      validatePassword(value);
                    });
                  },
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(
                          _showPassword
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InputField(
                  suffixIcon: const Icon(Icons.email_sharp),
                  enabled: !_isLoading,
                  label: "Email",
                  inputType: TextInputType.emailAddress,
                  controller: emailController,
                  errorText: emailErrorText,
                  validate: (String value) {
                    setState(() {
                      _errorText = null;
                      validateEmail(value);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InputField(
                  suffixIcon: const Icon(Icons.home_work_sharp),
                  enabled: !_isLoading,
                  controller: addressController,
                  label: "Address",
                  errorText: addressErrorText,
                  validate: (String value) {
                    setState(() {
                      _errorText = null;
                      validateAddress(value);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InputField(
                  suffixIcon: const Icon(Icons.phone_sharp),
                  enabled: !_isLoading,
                  inputType: TextInputType.phone,
                  controller: phoneNumberController,
                  label: "Phone number",
                  errorText: phoneNumberErrorText,
                  validate: (String value) {
                    setState(() {
                      _errorText = null;
                      validatePhoneNumber(value);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InputField(
                  suffixIcon: const Icon(Icons.calendar_today_sharp),
                  enabled: false,
                  controller: birthdateController,
                  label: "Birthday",
                  errorText: null,
                  validate: null,
                ),
              ),
              if (_errorText != null)
                Text(
                  _errorText!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              const SizedBox(height: 32),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: signInAndUpButtonSize,
                ),
                onPressed: isAllFieldsValid() && !_isLoading ? _signup : null,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Save",
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isAllFieldsValid() {
    bool isAllFieldsEntered = usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty;
    bool isAllFieldsWithoutError = usernameErrorText == null &&
        emailErrorText == null &&
        passwordErrorText == null &&
        addressErrorText == null &&
        phoneNumberErrorText == null;
    return isAllFieldsEntered && isAllFieldsWithoutError;
  }
}

bool isValidPassword(String pass) {
  return RegExp(
          r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[*&^%$#@!])[A-Za-z0-9*&^%$#@!]{8,}')
      .hasMatch(pass);
}

bool isValidEmail(String email) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

  return RegExp(pattern).hasMatch(email.toLowerCase());
}

bool isValidAddress(String address) {
  return RegExp(r'^[a-zA-Z\s]+, \d+, [a-zA-Z\s]+$').hasMatch(address);
}

bool isValidPhoneNumber(String phoneNumber) {
  return RegExp(
          r'^(?:(?:(\+?972|\(\+?972\)|\+?\(972\))(?:\s|\.|-)?([1-9]\d?))|(0[23489]{1})|(0[57]{1}[0-9]))(?:\s|\.|-)?([^0\D]{1}\d{2}(?:\s|\.|-)?\d{4})$')
      .hasMatch(phoneNumber);
}

DateTime? parseDate(String date) {
  try {
    return DateFormat("dd-MM-yyyy").tryParseStrict(date) != null
        ? DateFormat("dd-MM-yyyy").parseStrict(date)
        : DateFormat("dd/MM/yyyy").tryParseStrict(date) != null
            ? DateFormat("dd/MM/yyyy").parseStrict(date)
            : DateFormat("dd.mm.yyyy").parse(date);
  } catch (e) {
    return null;
  }
}

String getInitials(String name) {
  if (name.isEmpty) return '';
  List<String> words = name.split(' ');
  String initials = '';
  for (var word in words) {
    if (initials.length < 2) {
      initials += word[0].toUpperCase();
    }
  }
  return initials;
}
