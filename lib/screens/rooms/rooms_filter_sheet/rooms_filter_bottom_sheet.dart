import 'package:flutter/material.dart';
import '../../../utils/filters.dart';
import 'rooms_filter_sheet_col_contents.dart';

class FilterBottomSheet extends StatelessWidget {
  final ValueChanged<Filters> updateFiltersCallback;
  final ValueChanged<bool> isFiltersApplyConfirmed;
  final Filters oldFilters;

  const FilterBottomSheet({
    super.key,
    required this.updateFiltersCallback,
    required this.isFiltersApplyConfirmed,
    required this.oldFilters,
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
                  tempFilters: oldFilters,
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
