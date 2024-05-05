import 'package:flutter/material.dart';

import 'create_room_col_contents.dart';

class CreateRoomSideSheet extends StatefulWidget {
  final Function roomNameCallback;
  final Function roomMaxPlayersCallback;
  final Function roomQuestionsCountCallback;
  final Function roomTimePerQuestionCallback;
  final Function isCreationConfirmed;
  const CreateRoomSideSheet({
    super.key,
    required this.roomNameCallback,
    required this.roomMaxPlayersCallback,
    required this.roomQuestionsCountCallback,
    required this.roomTimePerQuestionCallback,
    required this.isCreationConfirmed,
  });

  @override
  State<CreateRoomSideSheet> createState() => _CreateRoomSideSheetState();
}

class _CreateRoomSideSheetState extends State<CreateRoomSideSheet> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
            )
          ),
          CreateRoomSheetActions(
            name: name,
            isCreationConfirmed: widget.isCreationConfirmed,
          )
        ],
      ),
    );
  }

}
