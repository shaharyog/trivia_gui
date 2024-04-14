import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_flutter_app_name/theme_provider.dart';
import 'package:your_flutter_app_name/utils.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(themeProvider.themeMode == ThemeMode.light
                      ? Icons.brightness_2
                      : Icons.brightness_6),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Login",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Login to your account",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: <Widget>[
                      makeInput(label: "User Name"),
                      makeInput(label: "Password", obscureText: true),
                    ],
                  ),
                ),
                FilledButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Login",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            "Sign up",
                            style:
                                Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
