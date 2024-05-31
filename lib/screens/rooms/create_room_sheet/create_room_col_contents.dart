import 'package:flutter/material.dart';

import '../../../utils/common_functionalities/seconds_to_readable.dart';

class CreateRoomSheetColContents extends StatelessWidget {
  final ValueChanged<String> roomNameCallback;
  final ValueChanged<double> roomMaxPlayersCallback;
  final ValueChanged<double> roomQuestionsCountCallback;
  final ValueChanged<double> roomTimePerQuestionCallback;
  final String name;
  final int maxPlayers;
  final int questionsCount;
  final int timePerQuestion;
  final bool isLoading;
  final String? errorText;

  const CreateRoomSheetColContents({
    super.key,
    required this.roomNameCallback,
    required this.roomMaxPlayersCallback,
    required this.roomQuestionsCountCallback,
    required this.roomTimePerQuestionCallback,
    required this.name,
    required this.maxPlayers,
    required this.questionsCount,
    required this.timePerQuestion,
    required this.isLoading,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final sliderTheme = SliderThemeData(
      inactiveTrackColor:
      Theme.of(context).colorScheme.primary.withOpacity(0.2),
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          enabled: !isLoading,
          onChanged: (value) {
            roomNameCallback(value);
          },
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16),
        Text(
          'Max Players:\t$maxPlayers',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SliderTheme(
          data: sliderTheme,
          child: Slider(
            value: maxPlayers.toDouble(),
            min: 2,
            max: 50,
            divisions: 48,
            label: maxPlayers.toString(),
            onChanged: !isLoading
                ? (value) {
                    roomMaxPlayersCallback(value);
                  }
                : null,
          ),
        ),
        Text(
          'Questions Count:\t$questionsCount',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SliderTheme(
          data: sliderTheme,
          child: Slider(
            value: questionsCount.toDouble(),
            min: 1,
            max: 50,
            divisions: 49,
            label: questionsCount.toString(),
            onChanged: !isLoading
                ? (value) {
                    roomQuestionsCountCallback(value);
                  }
                : null,
          ),
        ),
        Text(
          'Time per Question:\t${secondsToReadableTime(timePerQuestion)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SliderTheme(
          data: sliderTheme,
          child: Slider(
            value: timePerQuestion.toDouble(),
            min: 5,
            max: 180,
            divisions: 174,
            label: ' ${secondsToReadableTime(timePerQuestion)} ',
            onChanged: !isLoading
                ? (value) {
                    roomTimePerQuestionCallback(value);
                  }
                : null,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                errorText!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

class CreateRoomSheetActions extends StatelessWidget {
  final Function() onSave;
  final bool saveEnabled;
  final bool isLoading;

  const CreateRoomSheetActions(
      {super.key,
      required this.onSave,
      required this.saveEnabled,
      required this.isLoading});

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
                    onPressed: !isLoading && saveEnabled ? onSave : null,
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Create'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: OutlinedButton(
                    onPressed: !isLoading
                        ? () {
                            Navigator.of(context).pop();
                          }
                        : null,
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
