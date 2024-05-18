import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';
import '../../homepage/homepage.dart';
import '../../utils/common_functionalities/window_management.dart';
import '../../utils/common_widgets/gradient_text.dart';
import '../../utils/dialogs/server_settings.dart';
import '../../src/rust/api/error.dart';
import '../../src/rust/api/request/signup.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../../utils/common_widgets/input_field.dart';
import '../../utils/common_widgets/toggle_theme_button.dart';
import '../../utils/common_functionalities/user_data_validation.dart';

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
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  String? emailErrorText;
  FocusNode emailFocusNode = FocusNode();
  TextEditingController addressController = TextEditingController();
  String? addressErrorText;
  FocusNode addressFocusNode = FocusNode();
  TextEditingController phoneNumberController = TextEditingController();
  String? phoneNumberErrorText;
  FocusNode phoneNumberFocusNode = FocusNode();
  TextEditingController birthdateController = TextEditingController();
  String? birthdateErrorText;
  FocusNode birthdateFocusNode = FocusNode();

  bool _isLoading = false;
  String? _errorText;

  @override
  void initState() {
    setWindowTitle("Trivia - Signup");
    super.initState();
  }

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
        birthdateErrorText = getBirthdateErrorText(birthdateController.text);
      });
    }
  }

  Future<void> _signup() async {
    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final serverIp = prefs.getString(serverIpKey) ?? defaultServerIp;
    final serverPort = prefs.getString(serverPortKey) ?? defaultPort;

    try {
      Session newSession = await Session.signup(
        address: "$serverIp:$serverPort",
        signupRequest: SignupRequest(
            username: usernameController.text,
            password: passwordController.text,
            email: emailController.text.toLowerCase(),
            address: addressController.text,
            birthday: birthdateController.text,
            phoneNumber: phoneNumberController.text),
      );
      if (!mounted) return;
      setWindowTitle("Trivia - @${usernameController.text}");
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(session: newSession),
        ),
      );
    } on Error_SignupError catch (e) {
      setState(() {
        _errorText = "• ${e.format()}";
      });
    } on Error_ServerConnectionError catch (e) {
      if (!mounted) return;
      showErrorDialog(context, serverConnErrorText, e.format());
    } on Error catch (e) {
      if (!mounted) return;
      showErrorDialog(context, "Error", e.format());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            setWindowTitle("Trivia - Login");
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AnimatedGradientText(
                    "Signup",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                    colors: const [
                      Color(0xff84ffc9),
                      Color(0xffaab2ff),
                      Color(0xffeca0ff),
                    ],
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
                      suffixIcon: const Icon(Icons.person_outlined),
                      enabled: !_isLoading,
                      controller: usernameController,
                      errorText: usernameErrorText,
                      label: 'Username',
                      validate: (String value) {
                        setState(
                          () {
                            _errorText = null;
                            usernameErrorText = getUsernameErrorText(value);
                          },
                        );
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InputField(
                      focusNode: passwordFocusNode,
                      enabled: !_isLoading,
                      label: "Password",
                      inputType: TextInputType.visiblePassword,
                      controller: passwordController,
                      errorText: passwordErrorText,
                      showPassword: _showPassword,
                      isPassword: true,
                      validate: (String value) {
                        setState(
                          () {
                            _errorText = null;
                            passwordErrorText = getPasswordErrorText(value);
                          },
                        );
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(emailFocusNode);
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
                      focusNode: emailFocusNode,
                      suffixIcon: const Icon(Icons.email_outlined),
                      enabled: !_isLoading,
                      label: "Email",
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                      errorText: emailErrorText,
                      validate: (String value) {
                        setState(
                          () {
                            _errorText = null;
                            emailErrorText = getEmailErrorText(value);
                          },
                        );
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(addressFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InputField(
                      focusNode: addressFocusNode,
                      suffixIcon: const Icon(Icons.home_work_outlined),
                      enabled: !_isLoading,
                      controller: addressController,
                      label: "Address",
                      errorText: addressErrorText,
                      validate: (String value) {
                        setState(
                          () {
                            _errorText = null;
                            addressErrorText = getAddressErrorText(value);
                          },
                        );
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(phoneNumberFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InputField(
                        focusNode: phoneNumberFocusNode,
                        suffixIcon: const Icon(Icons.phone_outlined),
                        enabled: !_isLoading,
                        inputType: TextInputType.phone,
                        controller: phoneNumberController,
                        label: "Phone number",
                        errorText: phoneNumberErrorText,
                        validate: (String value) {
                          setState(
                            () {
                              _errorText = null;
                              phoneNumberErrorText =
                                  getPhoneNumberErrorText(value);
                            },
                          );
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(birthdateFocusNode);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: maxTextFieldWidth),
                      child: TextFormField(
                        focusNode: birthdateFocusNode,
                        enabled: !_isLoading,
                        readOnly: false,
                        onChanged: (String value) {
                          setState(
                            () {
                              _errorText = null;
                              birthdateErrorText = getBirthdateErrorText(value);
                            },
                          );
                        },
                        validator: (value) => birthdateErrorText,
                        controller: birthdateController,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: isAllFieldsValid() && !_isLoading
                            ? (value) {
                                _signup();
                              }
                            : null,
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
                    onPressed:
                        isAllFieldsValid() && !_isLoading ? _signup : null,
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
                                    setWindowTitle("Trivia - Login");
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
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
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
