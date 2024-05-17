import 'package:flutter/material.dart';
import 'package:trivia/consts.dart';
import '../../../providers/filters_providers/filters.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Number of questions:\t${tempFilters.questionCountRange.start.round()} - ${tempFilters.questionCountRange.end.round()}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SliderTheme(
          data: SliderThemeData(
            rangeValueIndicatorShape:
                const PaddleRangeSliderValueIndicatorShape(),
            inactiveTrackColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: RangeSlider(
            values: tempFilters.questionCountRange,
            min: defaultQuestionCountRangeStart,
            max: defaultQuestionCountRangeEnd,
            divisions: defaultQuestionCountRangeEnd.toInt(),
            labels: RangeLabels(
              tempFilters.questionCountRange.start.round().toString(),
              tempFilters.questionCountRange.end.round().toString(),
            ),
            onChanged: (values) {
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
          data: SliderThemeData(
            rangeValueIndicatorShape:
                const PaddleRangeSliderValueIndicatorShape(),
            inactiveTrackColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: RangeSlider(
            values: tempFilters.playersCountRange,
            min: defaultPlayersCountRangeStart,
            max: defaultPlayersCountRangeEnd,
            divisions: defaultPlayersCountRangeEnd.toInt(),
            labels: RangeLabels(
              tempFilters.playersCountRange.start.round().toString(),
              tempFilters.playersCountRange.end.round().toString(),
            ),
            onChanged: (values) {
              setState(() {
                tempFilters.playersCountRange = values;
                widget.updateFiltersCallback(tempFilters);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Show Only Active Rooms',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              Switch(
                value: tempFilters.showOnlyActive,
                onChanged: (value) {
                  setState(() {
                    tempFilters.showOnlyActive = value;
                    widget.updateFiltersCallback(tempFilters);
                  });
                },
              )
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
