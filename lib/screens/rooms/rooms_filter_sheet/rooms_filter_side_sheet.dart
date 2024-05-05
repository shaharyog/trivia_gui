import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/filters_providers/rooms_filters_provider.dart';
import 'rooms_filter_sheet_col_contents.dart';

class FilterSideSheet extends StatelessWidget {
  final Function updateFiltersCallback;
  final Function isFiltersApplyConfirmed;

  const FilterSideSheet({
    super.key,
    required this.updateFiltersCallback,
    required this.isFiltersApplyConfirmed,
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
                tempFilters: Provider.of<FiltersProvider>(context).filters,
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
