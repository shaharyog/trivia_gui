import 'package:flutter/material.dart';
import 'package:your_flutter_app_name/providers/filters_providers/rooms_temporary_filters_provider.dart';

List<Widget> RoomFilterSheetColContents(
    TemporaryFiltersProvider temporaryFiltersProvider, BuildContext context) {
  return <Widget>[
    Text(
      'Question Count',
      style: Theme.of(context).textTheme.titleMedium,
    ),
    SliderTheme(
      data: SliderThemeData(
        rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
        activeTickMarkColor: Colors.transparent,
        disabledActiveTickMarkColor: Colors.transparent,
        disabledInactiveTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child: RangeSlider(
        values: temporaryFiltersProvider.questionCountRange,
        min: 0,
        max: 100,
        divisions: 100,
        labels: RangeLabels(
          temporaryFiltersProvider.questionCountRange.start.round().toString(),
          temporaryFiltersProvider.questionCountRange.end.round().toString(),
        ),
        onChanged: (values) {
          temporaryFiltersProvider.updateQuestionCountRange(values);
        },
      ),
    ),
    SizedBox(height: 16),
    Text(
      'Players Count',
      style: Theme.of(context).textTheme.titleMedium,
    ),
    SliderTheme(
      data: SliderThemeData(
        rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
        activeTickMarkColor: Colors.transparent,
        disabledActiveTickMarkColor: Colors.transparent,
        disabledInactiveTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child: RangeSlider(
        values: temporaryFiltersProvider.playersCountRange,
        min: 0,
        max: 50,
        divisions: 50,
        labels: RangeLabels(
          temporaryFiltersProvider.playersCountRange.start.round().toString(),
          temporaryFiltersProvider.playersCountRange.end.round().toString(),
        ),
        onChanged: (values) {
          temporaryFiltersProvider.updatePlayersCountRange(values);
        },
      ),
    ),
    SizedBox(height: 16),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'isActive',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Switch(
          value: temporaryFiltersProvider.isActive,
          onChanged: (value) {
            temporaryFiltersProvider.updateIsActive(value);
          },
        )
      ],
    ),
  ];
}
