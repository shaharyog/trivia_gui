import 'package:flutter/material.dart';
import 'package:side_sheet_material3/side_sheet_material3.dart';

import '../../../providers/filters_providers/filters.dart';
import '../../../providers/filters_providers/rooms_filters_provider.dart';
import '../../../providers/screen_size_provider.dart';
import '../rooms_filter_sheet/rooms_filter_bottom_sheet.dart';
import '../rooms_filter_sheet/rooms_filter_side_sheet.dart';

Future<void> launchFilterSheet(
    BuildContext context,
    FiltersProvider filtersProvider,
    ScreenSizeProvider screenSizeProvider) async {
  Filters tempFilters = filtersProvider.filters;
  bool isConfirmed = false;

  if (screenSizeProvider.screenSize == ScreenSize.small) {
    await showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (context) => FilterBottomSheet(
        updateFiltersCallback: (value) {
          tempFilters = value;
        },
        isFiltersApplyConfirmed: (value) {
          isConfirmed = value;
        },
      ),
    );
  } else {
    await showModalSideSheet(
      addDivider: false,
      addBackIconButton: false,
      addActions: false,
      addCloseIconButton: false,
      barrierDismissible: true,
      context,
      body: FilterSideSheet(
        updateFiltersCallback: (value) {
          tempFilters = value;
        },
        isFiltersApplyConfirmed: (value) {
          isConfirmed = value;
        },
      ),
      header: "Filters",
    );
  }

  if (isConfirmed) {
    filtersProvider.applyTemporaryFilters(tempFilters);
  }
}
