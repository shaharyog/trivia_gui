import 'package:flutter/material.dart';
import 'package:trivia/consts.dart';
import '../../../utils/filters.dart';

class RoomFilterSheetColContents extends StatefulWidget {
  final ValueChanged<Filters> updateFiltersCallback;
  final Filters tempFilters;

  const RoomFilterSheetColContents({
    super.key,
    required this.updateFiltersCallback,
    required this.tempFilters,
  });

  @override
  State<RoomFilterSheetColContents> createState() =>
      _RoomFilterSheetColContentsState();
}

class _RoomFilterSheetColContentsState
    extends State<RoomFilterSheetColContents> {
  late Filters tempFilters;

  @override
  void initState() {
    super.initState();
    tempFilters = widget.tempFilters;
  }

  @override
  Widget build(BuildContext context) {
    final sliderTheme = SliderThemeData(
      rangeValueIndicatorShape: const PaddleRangeSliderValueIndicatorShape(),
      inactiveTrackColor:
          Theme.of(context).colorScheme.primary.withOpacity(0.2),
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Number of questions:\t${tempFilters.questionCountRange.start.round()} - ${tempFilters.questionCountRange.end.round()}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SliderTheme(
          data: sliderTheme,
          child: RangeSlider(
            values: tempFilters.questionCountRange,
            min: defaultQuestionCountRangeStart,
            max: defaultQuestionCountRangeEnd,
            divisions: defaultQuestionCountRangeEnd.toInt() - 1,
            labels: RangeLabels(
              tempFilters.questionCountRange.start.round().toString(),
              tempFilters.questionCountRange.end.round().toString(),
            ),
            onChanged: (values) {
              if (values.end - values.start < 5) {
                return; // do not allow the range to be less than 5
              }
              setState(() {
                tempFilters.questionCountRange = values;
                widget.updateFiltersCallback(tempFilters);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Number of online players:\t${tempFilters.playersCountRange.start.round()} - ${tempFilters.playersCountRange.end.round()}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SliderTheme(
          data: sliderTheme,
          child: RangeSlider(
            values: tempFilters.playersCountRange,
            min: defaultPlayersCountRangeStart,
            max: defaultPlayersCountRangeEnd,
            divisions: defaultPlayersCountRangeEnd.toInt() - 1,
            labels: RangeLabels(
              tempFilters.playersCountRange.start.round().toString(),
              tempFilters.playersCountRange.end.round().toString(),
            ),
            onChanged: (values) {
              if (values.end - values.start < 5) {
                return; // do not allow the range to be less than 5
              }
              setState(() {
                tempFilters.playersCountRange = values;
                widget.updateFiltersCallback(tempFilters);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        'Show rooms in which:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 5.0,
                spacing: 5.0,
                children: [
                  FilterChip(
                    label: const Text("game is running"),
                    selected: tempFilters.showActiveRooms,
                    onSelected: (bool selected) {
                      setState(() {
                        tempFilters.showActiveRooms = selected;
                        widget.updateFiltersCallback(tempFilters);
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text("game is waiting to start"),
                    selected: tempFilters.showInactiveRooms,
                    onSelected: (bool selected) {
                      setState(() {
                        tempFilters.showInactiveRooms = selected;
                        widget.updateFiltersCallback(tempFilters);
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text("game has ended"),
                    selected: tempFilters.showFinishedRooms,
                    onSelected: (bool selected) {
                      setState(() {
                        tempFilters.showFinishedRooms = selected;
                        widget.updateFiltersCallback(tempFilters);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RoomsFiltersSheetActions extends StatelessWidget {
  final ValueChanged<bool> isFiltersApplyConfirmed;

  const RoomsFiltersSheetActions({
    super.key,
    required this.isFiltersApplyConfirmed,
  });

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
                    onPressed: () {
                      isFiltersApplyConfirmed(true);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Apply'),
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
