import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet_material3/side_sheet_material3.dart';
import '../Objects/room.dart';
import '../providers/filters_providers/rooms_filters_provider.dart';
import '../providers/filters_providers/rooms_temporary_filters_provider.dart';
import '../providers/rooms_provider.dart';
import '../utils.dart';
import '../utils/rooms_filter_sheet/rooms_filter_bottom_sheet.dart';
import '../utils/rooms_filter_sheet/rooms_filter_side_sheet.dart';

class RoomsWidget extends StatelessWidget {
  final ScreenSize screenSize;

  RoomsWidget({required this.screenSize, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<FiltersProvider, RoomsProvider>(
      builder: (context, filtersProvider, roomsProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          filtersProvider.updateSearchText(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search rooms',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    IconButton(
                      onPressed: () {
                        TemporaryFiltersProvider tempFiltersProvider =
                            filtersProvider.temporaryFiltersProvider;

                        if (screenSize == ScreenSize.small) {
                          showModalBottomSheet<dynamic>(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                    value: tempFiltersProvider,
                                    child: FilterBottomSheet(),
                                  ));
                        } else {
                          showModalSideSheet(
                            confirmActionTitle: "Apply",
                            confirmActionOnPressed: () {
                              filtersProvider
                                  .applyTemporaryFilters(tempFiltersProvider);
                              Navigator.pop(context); // Close side sheet
                            },
                            addCloseIconButton: false,
                            barrierDismissible: true,
                            context,
                            body: ChangeNotifierProvider.value(
                              value: tempFiltersProvider,
                              child: FilterSideSheet(),
                            ),
                            header: "Filters",
                          );
                        }
                      },
                      icon: Icon(Icons.tune),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: roomsProvider.filteredRooms.length,
                  itemBuilder: (context, index) {
                    final room = roomsProvider.filteredRooms[index];
                    return RoomCard(room: room);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RoomCard extends StatelessWidget {
  final Room room;

  RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(room.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: RoomLeadingStatus(room: room),
        subtitle: RoomSubtitleInfo(room: room),
      ),
    );
  }
}

Widget RoomSubtitleInfo({required Room room}) {
  return Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: Row(
      children: [
        Icon(Icons.group_outlined, size: 16),
        SizedBox(width: 4),
        Text('${room.maxPlayers}'),
        SizedBox(width: 12),
        Icon(Icons.question_mark, size: 16),
        SizedBox(width: 2),
        Text('${room.questionsCount}'),
        SizedBox(width: 12),
        Icon(Icons.timer_outlined, size: 16),
        SizedBox(width: 4),
        Text('${room.timePerQuestion}'),
        SizedBox(width: 16),
        Icon(Icons.groups, size: 16),
        SizedBox(width: 4),
        Text('${room.players.length}'),
      ],
    ),
  );
}

Widget RoomLeadingStatus({required Room room}) {
  return Padding(
    padding: const EdgeInsets.only(left: 4.0),
    child: Container(
      width: 12.0,
      height: 12.0,
      decoration: BoxDecoration(
        color: room.isActive ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      ),
    ),
  );
}
