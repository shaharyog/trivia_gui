import 'package:flutter/material.dart';
import '../../../utils/filters.dart';
import 'rooms_filter_sheet_col_contents.dart';

class FilterSideSheet extends StatelessWidget {
  final ValueChanged<Filters> updateFiltersCallback;
  final ValueChanged<bool> isFiltersApplyConfirmed;
  final Filters oldFilters;

  const FilterSideSheet({
    super.key,
    required this.updateFiltersCallback,
    required this.isFiltersApplyConfirmed,
    required this.oldFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: RoomFilterSheetColContents(
                tempFilters: oldFilters,
                updateFiltersCallback: updateFiltersCallback,
              ),
            ),
          ),
          RoomsFiltersSheetActions(
            isFiltersApplyConfirmed: isFiltersApplyConfirmed,
          ),
        ],
      ),
    );
  }
}
