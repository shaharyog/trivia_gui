import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/screens/profile/profile_contents.dart';
import 'package:trivia/src/rust/api/error.dart';
import '../../providers/session_provider.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          if (snapshot.error is Error_ServerConnectionError) {
            Provider.of<SessionProvider>(context, listen: false).session = null;
            Future.microtask(
                () => Navigator.of(context).pushReplacementNamed('/login'));
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text((snapshot.error as Error).format()),
              const SizedBox(
                height: 16.0,
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text("Try Again"),
              )
            ],
          ));
        }
        final userData = snapshot.data!;
        return ProfilePageContent(userData: userData);
      },
      future: Provider.of<SessionProvider>(context, listen: false)
          .session!
          .getUserData(),
    );
  }
}


