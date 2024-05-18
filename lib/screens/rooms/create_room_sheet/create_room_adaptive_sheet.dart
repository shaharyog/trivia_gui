import 'package:flutter/material.dart';
import '../../../utils/dialogs/error_dialog.dart';
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
  State<CreateRoomAdaptiveSheet> createState() => _CreateRoomAdaptiveSheetState();
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
          Navigator.of(context).pop();
        } on Error_ServerConnectionError catch (e) {
          if (!context.mounted) return;
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/login');
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return ErrorDialog(
                  title: "Server Connection Error",
                  message: "${e.format()}, Returning to login page...");
            },
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
    return !widget.isSideSheet
        ? Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Create Room',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    SingleChildScrollView(
                      child: content,
                    ),
                    actions,
                  ],
                ),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: content,
                  ),
                ),
                actions,
              ],
            ),
          );
  }
}
