import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/filters_providers/rooms_filters_provider.dart';
import 'rooms_filter_sheet_col_contents.dart';

class FilterBottomSheet extends StatelessWidget {
  final Function updateFiltersCallback;
  final Function isFiltersApplyConfirmed;

  const FilterBottomSheet({
    super.key,
    required this.updateFiltersCallback,
    required this.isFiltersApplyConfirmed,
  });

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
                  'Filters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SingleChildScrollView(
                child: RoomFilterSheetColContents(
                  tempFilters: Provider.of<FiltersProvider>(context).filters,
                  updateFiltersCallback: updateFiltersCallback,
                ),
              ),
              RoomsFiltersSheetActions(
                isFiltersApplyConfirmed: isFiltersApplyConfirmed,
              )
            ],
          ),
        ),
      ],
    );
  }
}
