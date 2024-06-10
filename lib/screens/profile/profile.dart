import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trivia/screens/profile/profile_contents.dart';
import 'package:trivia/src/rust/api/error.dart';
import 'package:trivia/src/rust/api/request/get_user_data.dart';
import '../../consts.dart';
import '../../src/rust/api/session.dart';
import '../../utils/dialogs/error_dialog.dart';
import '../auth/login.dart';

class ProfilePage extends StatefulWidget {
  final Session session;

  const ProfilePage({super.key, required this.session});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserDataAndStatistics> future;

  @override
  void initState() {
    future = getUserDataAndStats(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              child: ProfilePageContent(
                userDataAndStats: fakeUserDataAndStats,
                session: widget.session,
              ),
            );
          }
          if (snapshot.hasError) {
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
                      setState(() {
                        future = getUserDataAndStats(context);
                      });
                    },
                    child: const Text("Try Again"),
                  )
                ],
              ),
            );
          }
          final userData = snapshot.data!;
          return Skeletonizer(
            enabled: false,
            child: ProfilePageContent(
              userDataAndStats: userData,
              session: widget.session,
            ),
          );
        },
        future: future,
      ),
    );
  }

  Future<UserDataAndStatistics> getUserDataAndStats(BuildContext context) {
    return widget.session.getUserData().onError(
      (Error_ServerConnectionError error, stackTrace) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              errorDialogData: ErrorDialogData(
                title: serverConnErrorText,
                message: error.format(),
              ),
            ),
          ),
        );
        return fakeUserDataAndStats;
      },
    );
  }
}
