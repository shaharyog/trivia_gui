import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/screens/profile/profile_contents.dart';
import 'package:trivia/src/rust/api/error.dart';
import 'package:trivia/src/rust/api/request/get_user_data.dart';
import 'package:trivia/utils/common_functionalities/reset_providers.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';

class ProfilePage extends StatefulWidget {
  final Session session;

  const ProfilePage({super.key, required this.session});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserData> future;
  @override
  void initState() {
    future = widget.session.getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // show skeleton while loading, create fake data in order to show skeleton in the right shape
          final UserData fakeUserData = UserData(
              username: "username",
              email: "username@gmail.com",
              address: "Street, 123, City",
              phoneNumber: "0555555555",
              birthday: "01/01/2000",
              avatarColor: "Blue",
              memberSince: DateTime(2000, 1, 1));
          return Skeletonizer(
            child: ProfilePageContent(
              userData: fakeUserData,
              isSkeletonLoading: true,
              session: widget.session,
            ),
          );
        }
        if (snapshot.hasError) {
          // logout when server connection error occurred
          if (snapshot.error is Error_ServerConnectionError) {
            resetProviders(context);
            Future.microtask(() {
              Navigator.of(context).pushReplacementNamed('/login');
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return ErrorDialog(
                      title: "Server Connection Error",
                      message:
                          "${(snapshot.error as Error).format()}, Returning to login page...");
                },
              );
            });
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
          );
        }
        final userData = snapshot.data!;
        return ProfilePageContent(userData: userData, session: widget.session,);
      },
      future: future,
    );
  }
}
