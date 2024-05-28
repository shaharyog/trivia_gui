import 'package:flutter/material.dart';
import '../../../consts.dart';
import '../../../utils/common_widgets/gradient_text.dart';
import '../../../utils/dialogs/error_dialog.dart';
import '../../auth/login.dart';
import 'create_room_col_contents.dart';
import 'package:trivia/src/rust/api/error.dart';

class CreateRoomAdaptiveSheet extends StatefulWidget {
  final Future<void> Function(
          String name, int maxPlayers, int questionsCount, int timePerQuestion)
      onSave;
  final bool isSideSheet;

  const CreateRoomAdaptiveSheet(
      {super.key, required this.onSave, required this.isSideSheet});

  @override
  State<CreateRoomAdaptiveSheet> createState() =>
      _CreateRoomAdaptiveSheetState();
}

class _CreateRoomAdaptiveSheetState extends State<CreateRoomAdaptiveSheet> {
  String name = '';
  int maxPlayers = 2;
  int questionsCount = 2;
  int timePerQuestion = 2;
  bool _isLoading = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final actions = CreateRoomSheetActions(
      isLoading: _isLoading,
      onSave: () async {
        setState(() {
          _isLoading = true;
        });
        try {
          await widget.onSave(
            name,
            maxPlayers,
            questionsCount,
            timePerQuestion,
          );
          if (!context.mounted) return;
          Navigator.pop(context);
        } on Error_ServerConnectionError catch (e) {
          if (!context.mounted) return;
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                errorDialogData: ErrorDialogData(
                  title: serverConnErrorText,
                  message: e.format(),
                ),
              ),
            ),
          );
        } on Error catch (e) {
          if (!context.mounted) return;
          setState(() {
            errorText = "• ${e.format()}";
          });
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      },
      saveEnabled: name.isNotEmpty,
    );
    final content = CreateRoomSheetColContents(
      errorText: errorText,
      isLoading: _isLoading,
      name: name,
      maxPlayers: maxPlayers,
      questionsCount: questionsCount,
      timePerQuestion: timePerQuestion,
      roomNameCallback: (value) {
        setState(() {
          name = value;
        });
      },
      roomMaxPlayersCallback: (value) {
        setState(() {
          maxPlayers = value.toInt();
        });
      },
      roomQuestionsCountCallback: (value) {
        setState(() {
          questionsCount = value.toInt();
        });
      },
      roomTimePerQuestionCallback: (value) {
        setState(() {
          timePerQuestion = value.toInt();
        });
      },
    );
    final header = AnimatedGradientText(
      "Create Room",
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
      colors: const [
        Color(0xffdff2cb),
        Color(0xfff0a13a),
        Color(0xffee609a),
      ],
    );

    return PopScope(
      canPop: !_isLoading,
      child: !widget.isSideSheet
          ? Padding(
              padding: MediaQuery.of(context).viewInsets.copyWith(
                    left: 16.0,
                    right: 16.0,
                  ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: header),
                  ),
                  content,
                  actions,
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Center(child: header),
                  ),
                  content,
                  actions,
                ],
              ),
            ),
    );
  }
}
