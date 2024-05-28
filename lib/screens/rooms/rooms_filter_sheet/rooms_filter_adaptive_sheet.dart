import 'package:flutter/material.dart';
import 'package:trivia/utils/common_widgets/gradient_text.dart';
import '../../../utils/filters.dart';
import 'rooms_filter_sheet_col_contents.dart';

class RoomsFilterAdaptiveSheet extends StatelessWidget {
  final ValueChanged<Filters> updateFiltersCallback;
  final ValueChanged<bool> isFiltersApplyConfirmed;
  final Filters oldFilters;
  final bool isSideSheet;

  const RoomsFilterAdaptiveSheet({
    super.key,
    required this.updateFiltersCallback,
    required this.isFiltersApplyConfirmed,
    required this.oldFilters,
    this.isSideSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    final actions = RoomsFiltersSheetActions(
      isFiltersApplyConfirmed: isFiltersApplyConfirmed,
    );
    final contents = RoomFilterSheetColContents(
      tempFilters: oldFilters,
      updateFiltersCallback: updateFiltersCallback,
    );
    final header = AnimatedGradientText(
      "Filter",
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
      colors: const [
        Color(0xff68e3f9),
        Color(0xfff55a9b),
        Color(0xff4f4ed7),
      ],
      duration: const Duration(milliseconds: 1300),
    );
    return !isSideSheet
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                    child: header,
                  ),
                  contents,
                  actions,
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: header,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: contents,
                  ),
                ),
                actions,
              ],
            ),
          );
  }
}
