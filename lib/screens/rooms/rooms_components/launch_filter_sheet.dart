import 'package:flutter/material.dart';
import 'package:side_sheet_material3/side_sheet_material3.dart';
import '../../../utils/filters.dart';
import '../../../utils/common_functionalities/screen_size.dart';
import '../rooms_filter_sheet/rooms_filter_adaptive_sheet.dart';

Future<Filters?> launchFilterSheet(
  BuildContext context,
  Filters filters,
) async {
  bool isConfirmed = false;

  if (getScreenSize(context) == ScreenSize.small) {
    await showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (context) => RoomsFilterAdaptiveSheet(
        oldFilters: Filters.fromFilters(filters),
        updateFiltersCallback: (newFilters) {
          filters = newFilters;
        },
        isFiltersApplyConfirmed: (confirmed) {
          isConfirmed = confirmed;
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
      body: RoomsFilterAdaptiveSheet(
        oldFilters: Filters.fromFilters(filters),
        updateFiltersCallback: (newFilters) {
          filters = newFilters;
        },
        isFiltersApplyConfirmed: (confirmed) {
          isConfirmed = confirmed;
        },
        isSideSheet: true,
      ),
      header: "",
    );
  }

  if (isConfirmed) {
    return filters;
  }

  return null;
}
