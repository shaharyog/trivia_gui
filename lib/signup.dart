import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_flutter_app_name/theme_provider.dart';
import 'package:your_flutter_app_name/utils.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(themeProvider.themeMode == ThemeMode.light
                    ? Icons.brightness_2
                    : Icons.brightness_6),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account, It's free",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: <Widget>[
                    makeInput(label: "User Name"),
                    makeInput(label: "Password", obscureText: true),
                    makeInput(label: "Email"),
                    makeInput(label: "Address"),
                    makeInput(label: "Phone Number"),
                    makeInput(label: "Birthday"),
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
                  "Sign up",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text("Already have an account? "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        "Sign in",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
