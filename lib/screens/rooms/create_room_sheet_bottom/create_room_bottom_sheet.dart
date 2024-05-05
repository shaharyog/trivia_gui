import 'package:flutter/material.dart';
import 'create_room_col_contents.dart';

class CreateRoomBottomSheet extends StatefulWidget {
  final Function roomNameCallback;
  final Function roomMaxPlayersCallback;
  final Function roomQuestionsCountCallback;
  final Function roomTimePerQuestionCallback;
  final Function isCreationConfirmed;

  const CreateRoomBottomSheet({
    super.key,
    required this.roomNameCallback,
    required this.roomMaxPlayersCallback,
    required this.roomQuestionsCountCallback,
    required this.roomTimePerQuestionCallback,
    required this.isCreationConfirmed,
  });

  @override
  State<CreateRoomBottomSheet> createState() => _CreateRoomBottomSheetState();
}

class _CreateRoomBottomSheetState extends State<CreateRoomBottomSheet> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
                child: CreateRoomSheetColContents(
                  roomNameCallback: (value) {
                    setState(() {
                      name = value;
                      widget.roomNameCallback(name);
                    });
                  },
                  roomMaxPlayersCallback: widget.roomMaxPlayersCallback,
                  roomQuestionsCountCallback: widget.roomQuestionsCountCallback,
                  roomTimePerQuestionCallback: widget.roomTimePerQuestionCallback,
                ),
              ),
              CreateRoomSheetActions(
                name: name,
                isCreationConfirmed: widget.isCreationConfirmed,
              )
            ],
          ),
        ),
      ],
    );
  }
}
