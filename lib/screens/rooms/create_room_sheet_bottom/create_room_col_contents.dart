import 'package:flutter/material.dart';

import '../../../utils/common_functionalities/seconds_to_readable.dart';

class CreateRoomSheetColContents extends StatefulWidget {
  final Function roomNameCallback;
  final Function roomMaxPlayersCallback;
  final Function roomQuestionsCountCallback;
  final Function roomTimePerQuestionCallback;

  const CreateRoomSheetColContents({
    super.key,
    required this.roomNameCallback,
    required this.roomMaxPlayersCallback,
    required this.roomQuestionsCountCallback,
    required this.roomTimePerQuestionCallback,
  });

  @override
  State<CreateRoomSheetColContents> createState() =>
      _CreateRoomSheetColContentsState();
}

class _CreateRoomSheetColContentsState
    extends State<CreateRoomSheetColContents> {
  String name = '';
  int maxPlayers = 2;
  int questionsCount = 2;
  int timePerQuestion = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              name = value;
              widget.roomNameCallback(name);
            });
          },
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Max Players:\t$maxPlayers',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SliderTheme(
          data: SliderThemeData(
            inactiveTrackColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: Slider(
            value: maxPlayers.toDouble(),
            min: 2,
            max: 50,
            divisions: 48,
            label: maxPlayers.toString(),
            onChanged: (value) {
              setState(() {
                maxPlayers = value.toInt();
                widget.roomMaxPlayersCallback(maxPlayers);
              });
            },
          ),
        ),
        Text(
          'Questions Count:\t$questionsCount',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SliderTheme(
          data: SliderThemeData(
            inactiveTrackColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: Slider(
            value: questionsCount.toDouble(),
            min: 2,
            max: 50,
            divisions: 49,
            label: questionsCount.toString(),
            onChanged: (value) {
              setState(() {
                questionsCount = value.toInt();
                widget.roomQuestionsCountCallback(questionsCount);
              });
            },
          ),
        ),
        Text(
          'Time per Question:\t${secondsToReadableTime(timePerQuestion)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SliderTheme(
          data: SliderThemeData(
            inactiveTrackColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: Slider(
            value: timePerQuestion.toDouble(),
            min: 1,
            max: 180,
            divisions: 179,
            label: ' ${secondsToReadableTime(timePerQuestion)} ',
            onChanged: (value) {
              setState(() {
                timePerQuestion = value.toInt();
                widget.roomTimePerQuestionCallback(timePerQuestion);
              });
            },
          ),
        ),
      ],
    );
  }
}

class CreateRoomSheetActions extends StatelessWidget {
  final Function isCreationConfirmed;
  final String name;

  const CreateRoomSheetActions(
      {super.key, required this.isCreationConfirmed, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilledButton(
                    onPressed: name.isEmpty
                        ? null
                        : () {
                            isCreationConfirmed(true);
                            Navigator.of(context).pop();
                          },
                    child: const Text('Create'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
