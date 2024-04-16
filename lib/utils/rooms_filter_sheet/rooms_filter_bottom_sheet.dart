import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/filters_providers/rooms_filters_provider.dart';
import '../../providers/filters_providers/rooms_temporary_filters_provider.dart';
import 'rooms_filter_sheet_col_contents.dart';

class FilterBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final temporaryFiltersProvider = context.watch<TemporaryFiltersProvider>();

    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              ...RoomFilterSheetColContents(temporaryFiltersProvider, context),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () {
                      // Apply temporary filters to the main FiltersProvider
                      final mainFiltersProvider =
                          context.read<FiltersProvider>();
                      mainFiltersProvider
                          .applyTemporaryFilters(temporaryFiltersProvider);
                      Navigator.of(context).pop();
                    },
                    child: Text('Apply'),
                  ),
                  SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text('Cancel'),
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
