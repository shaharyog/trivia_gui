import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia/src/rust/api/error.dart';
import 'package:trivia/src/rust/api/request/login.dart';
import 'package:trivia/utils/common_widgets/input_field.dart';
import '../../consts.dart';
import '../../homepage/homepage.dart';
import '../../utils/common_functionalities/window_management.dart';
import '../../utils/common_widgets/gradient_text.dart';
import '../../utils/dialogs/server_settings.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../../utils/common_widgets/toggle_theme_button.dart';

class LoginPage extends StatefulWidget {
  final ErrorDialogData? errorDialogData;
  final Session? previousSession; // in order to logout
  const LoginPage({super.key, this.errorDialogData, this.previousSession});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  String? loginError;
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void initState() {
    var errorDialogData = widget.errorDialogData;
    super.initState();
    setWindowTitle("Trivia - Login");
    if (widget.previousSession != null && widget.errorDialogData == null) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) async {
          try {
            await widget.previousSession!.logout();
          } on Error_LogoutError catch (e) {
            errorDialogData = ErrorDialogData(
              title: logoutErrorText,
              message: e.format(),
            );
          } on Error_ServerConnectionError catch (e) {
            errorDialogData = ErrorDialogData(
              title: serverConnErrorText,
              message: e.format(),
            );
          } on Error catch (e) {
            errorDialogData = ErrorDialogData(
              title: unknownErrorText,
              message: e.format(),
            );
          }
        }
      );
    }
    if (errorDialogData != null) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => showErrorDialog(
          context,
          errorDialogData!.title,
          errorDialogData!.message,
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      loginError = null;
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final serverIp = prefs.getString(serverIpKey) ?? defaultServerIp;
    final serverPort = prefs.getString(serverPortKey) ?? defaultPort;

    try {
      Session newSession = await Session.login(
        loginRequest: LoginRequest(
          username: usernameController.text,
          password: passwordController.text,
        ),
        address: "$serverIp:$serverPort",
      );

      if (!mounted) return;
      setWindowTitle("Trivia - @${usernameController.text}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(session: newSession),
        ),
      );
    } on Error_LoginError catch (_) {
      setState(() {
        loginError =
            "• Invalid username or password, or user already logged in";
      });
    } on Error_ServerConnectionError catch (e) {
      if (!mounted) return;
      showErrorDialog(context, serverConnErrorText, e.format());
    } on Error catch (e) {
      if (!mounted) return;
      showErrorDialog(context, unknownErrorText, e.format());
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: themeToggleButton(context),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedGradientText(
                    "Login",
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
                    "Login to your account",
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
                      errorText: loginError,
                      validate: (value) {
                        setState(() {
                          loginError = null;
                        });
                      },
                      onFieldSubmitted: (value) {
                        // move focus to next field (password)
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                      label: "Username",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InputField(
                      focusNode: passwordFocusNode,
                      enabled: !_isLoading,
                      controller: passwordController,
                      errorText: loginError,
                      validate: (value) {
                        setState(() {
                          loginError = null;
                        });
                      },
                      label: "Password",
                      inputType: TextInputType.visiblePassword,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: isAllCredentialsEntered() && !_isLoading
                          ? (value) {
                              _login();
                            }
                          : null,
                      showPassword: _showPassword,
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
                  const SizedBox(height: 32),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: signInAndUpButtonSize,
                    ),
                    onPressed: isAllCredentialsEntered() && !_isLoading
                        ? _login
                        : null,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Login",
                          ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32.0,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: !_isLoading
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context).disabledColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = !_isLoading
                                    ? () {
                                        Navigator.pushNamed(context, '/signup');
                                      }
                                    : null,
                              mouseCursor: !_isLoading
                                  ? SystemMouseCursors.click
                                  : MouseCursor.defer,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isAllCredentialsEntered() {
    return usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }
}
