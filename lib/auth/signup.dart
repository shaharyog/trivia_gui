import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts.dart';
import '../providers/session_provider.dart';
import '../server_settings.dart';
import '../src/rust/api/error.dart';
import '../src/rust/api/request/signup.dart';
import '../src/rust/api/session.dart';
import '../utils/error_dialog.dart';
import '../utils/input_field.dart';
import '../utils/toggle_theme_button.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
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
  TextEditingController birthdateController = TextEditingController();
  String? birthdateErrorText;
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  void _selectBirthdate() async {
    setState(() {
      _errorText = null;
    });

    final DateTime? pickedDate = await showDatePicker(
      fieldLabelText: "Birthdate",
      context: context,
      initialDate: parseDate(birthdateController.text) ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthdateController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
      setState(() {
        validateBirthdate(birthdateController.text);
      });
    }
  }

  void validateBirthdate(String value) {
    if (value.isEmpty) {
      birthdateErrorText = null;
    } else {
      DateTime? date = parseDate(value);
      if (date == null) {
        birthdateErrorText = "• Invalid birthdate format";
        return;
      }

      if (date.isBefore(DateTime(1900, 1, 1)) || date.isAfter(DateTime.now())) {
        birthdateErrorText = "• Invalid birthdate";
      } else {
        birthdateErrorText = null;
      }
    }
  }

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
    final prefs = await SharedPreferences.getInstance();
    final serverIp = prefs.getString(serverIpKey);
    final serverPort = prefs.getString(serverPortKey);
    try {
      sessionProvider.session = await Session.signup(
        address: "$serverIp:$serverPort",
        signupRequest: SignupRequest(
            username: usernameController.text,
            password: passwordController.text,
            email: emailController.text.toLowerCase(),
            address: addressController.text,
            birthday: birthdateController.text,
            phoneNumber: phoneNumberController.text),
      );
    } on Error_SignupError catch (e) {
      setState(() {
        _errorText = "• ${e.format()}";
      });
      return;
    } on Error_ServerConnectionError catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            title: "Server Connection Error",
            message: e.format(),
          );
        },
      );
      return;
    } on Error catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            title: "Error",
            message: e.format(),
          );
        },
      );
      return;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !_isLoading,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: themeToggleButton(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Hero(
              tag: "settings_icon_button",
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const SettingsDialog(),
                  );
                },
                icon: const Icon(Icons.settings_sharp),
              ),
            ),
          )
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
                    suffixIcon: const Icon(Icons.person_sharp),
                    enabled: !_isLoading,
                    controller: usernameController,
                    errorText: usernameErrorText,
                    label: 'Username',
                    validate: (String value) {
                      setState(() {
                        _errorText = null;
                        validateUsername(value);
                      });
                    },
                  ),
                ),
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
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: maxTextFieldWidth),
                    child: TextFormField(
                      enabled: !_isLoading,
                      readOnly: false,
                      onChanged: (String value) {
                        setState(() {
                          _errorText = null;
                          validateBirthdate(value);
                        });
                      },
                      validator: (value) => birthdateErrorText,
                      controller: birthdateController,
                      keyboardType: TextInputType.datetime,
                      textInputAction: isAllFieldsValid()
                          ? TextInputAction.next
                          : TextInputAction.done,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Birthdate",
                        errorText: birthdateErrorText,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: IconButton(
                            icon: const Icon(Icons.edit_calendar_sharp),
                            onPressed: () => _selectBirthdate(),
                          ),
                        ),
                      ),
                    ),
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
                          onTap: !_isLoading
                              ? () {
                                  Navigator.pop(context);
                                }
                              : null,
                          child: MouseRegion(
                            cursor: !_isLoading
                                ? SystemMouseCursors.click
                                : MouseCursor.defer,
                            child: Text(
                              "Login",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: !_isLoading
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).disabledColor,
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

  bool isAllFieldsValid() {
    bool isAllFieldsEntered = usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        birthdateController.text.isNotEmpty;
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
