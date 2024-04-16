import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/filters_providers/rooms_temporary_filters_provider.dart';
import 'rooms_filter_sheet_col_contents.dart';

class FilterSideSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final temporaryFiltersProvider = context.watch<TemporaryFiltersProvider>();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: RoomFilterSheetColContents(temporaryFiltersProvider, context),
      ),
    );
  }
}
