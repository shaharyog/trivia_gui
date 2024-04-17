import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/filters_providers/rooms_filters_provider.dart';
import '../../providers/rooms_provider.dart';
import '../../providers/screen_size_provider.dart';
import 'rooms_components/launch_filter_sheet.dart';
import 'rooms_components/room_card.dart';

class RoomsWidget extends StatefulWidget {
  const RoomsWidget({super.key});

  @override
  State<RoomsWidget> createState() => _RoomsWidgetState();
}

class _RoomsWidgetState extends State<RoomsWidget> with SingleTickerProviderStateMixin{
  late AnimationController _blinkingController;

  @override
  void initState() {
    super.initState();
    _blinkingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkingController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer3<FiltersProvider, RoomsProvider, ScreenSizeProvider>(
      builder:
          (context, filtersProvider, roomsProvider, screenSizeProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        onChanged: (value) {
                          filtersProvider.updateSearchText(value);
                        },
                        hintText: 'Search rooms',
                        hintStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              );
                            } else {
                              return const TextStyle();
                            }
                          },
                        ),
                        leading: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.search),
                        ),
                        trailing: <Widget>[
                          IconButton(
                            onPressed: filtersProvider.sortBy == SortBy.nothing
                                ? null
                                : () {
                                    setState(() {
                                      filtersProvider.setIsReversedSort(
                                          !filtersProvider.isReversedSort);
                                    });
                                    // Implement logic to sort rooms based on _isAscending
                                  },
                            icon: Icon(
                              filtersProvider.isReversedSort
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: filtersProvider.sortBy == SortBy.nothing
                                  ? null
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          PopupMenuButton<SortBy>(
                            tooltip: '',
                            icon: Icon(
                              Icons.sort,
                              color: filtersProvider.doesSorting()
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            onSelected: (SortBy selectedSortBy) {
                              filtersProvider.setSortBy(selectedSortBy);
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<SortBy>>[
                              const PopupMenuItem<SortBy>(
                                value: SortBy.nothing,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.clear),
                                    ),
                                    Text('None'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<SortBy>(
                                value: SortBy.playersCount,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.people),
                                    ),
                                    Text('Sort by Number of Online Players'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<SortBy>(
                                value: SortBy.questionsCount,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.question_mark),
                                    ),
                                    Text('Sort by Number of Questions'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<SortBy>(
                                value: SortBy.timePerQuestion,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.timer),
                                    ),
                                    Text('Sort by Time Per Question'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              await launchFilterSheet(
                                  context, filtersProvider, screenSizeProvider);
                            },
                            icon: Icon(
                              Icons.tune,
                              color: filtersProvider.doesFiltering()
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: roomsProvider.filteredRooms.length,
                  itemBuilder: (context, index) {
                    final room = roomsProvider.filteredRooms[index];
                    return RoomCard(room: room, blinkingController: _blinkingController, );
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
