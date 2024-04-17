import 'package:flutter/material.dart';
import '../rooms_provider.dart';

class Filters {
  String searchText = '';
  RangeValues questionCountRange = const RangeValues(0, 100);
  RangeValues playersCountRange = const RangeValues(0, 50);
  bool showOnlyActive = false;
  SortBy sortBy = SortBy.nothing;
  bool putActiveRoomsFirst = false;
  bool isReversedSort = false;
}