import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia/src/rust/api/error.dart';
import 'package:trivia/src/rust/api/request/login.dart';
import 'package:trivia/utils/input_field.dart';
import '../consts.dart';
import '../providers/session_provider.dart';
import '../server_settings.dart';
import '../src/rust/api/session.dart';
import '../utils/error_dialog.dart';
import '../utils/toggle_theme_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? loginError;
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      loginError = null;
      _isLoading = true;
    });
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final serverIp = prefs.getString(serverIpKey) ?? defaultServerIp;
    final serverPort = prefs.getString(serverPortKey) ?? defaultPort;
    try {
      sessionProvider.session = await Session.login(
        loginRequest: LoginRequest(
          username: usernameController.text,
          password: passwordController.text,
        ),
        address:
            "$serverIp:$serverPort",
      );
    } on Error_LoginError catch (_) {
      setState(() {
        loginError = "• Invalid username or password, or user already logged in from another device";
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
        automaticallyImplyLeading: false,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium,
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
                    label: "Username",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputField(
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
                    textInputAction: isAllCredentialsEntered()
                        ? TextInputAction.next
                        : TextInputAction.done,
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
                  onPressed:
                      isAllCredentialsEntered() && !_isLoading ? _login : null,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Login",
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
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: !_isLoading ? () {
                            Navigator.pushNamed(context, '/signup');
                          } : null,
                          child: MouseRegion(
                            cursor: !_isLoading ? SystemMouseCursors.click : MouseCursor.defer,
                            child: Text(
                              "Sign up",
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
                        ),
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

  bool isAllCredentialsEntered() {
    return usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }
}
