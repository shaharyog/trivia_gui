import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../consts.dart';
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

class _RoomsWidgetState extends State<RoomsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkingController;

  @override
  void initState() {
    super.initState();
    _blinkingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: defaultBlinkingCircleDuration),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomsProvider = Provider.of<RoomsProvider>(context);
    final filtersProvider = Provider.of<FiltersProvider>(context);
    final screenSizeProvider = Provider.of<ScreenSizeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    surfaceTintColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.05);
                    }),
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
                      child: Icon(Icons.search_sharp),
                    ),
                    trailing: <Widget>[
                      GestureDetector(
                        onLongPress: () {
                          filtersProvider.resetSortDirection();
                        },
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              filtersProvider.setIsReversedSort(
                                  !filtersProvider.isReversedSort);
                            });
                          },
                          icon: Icon(
                            filtersProvider.isReversedSort
                                ? Icons.arrow_downward_sharp
                                : Icons.arrow_upward_sharp,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () {
                          filtersProvider.resetSort();
                        },
                        child: PopupMenuButton<SortBy>(
                          tooltip: '',
                          icon: Icon(
                            Icons.sort_sharp,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onSelected: (SortBy selectedSortBy) {
                            filtersProvider.setSortBy(selectedSortBy);
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<SortBy>>[
                            PopupMenuItem<SortBy>(
                              value: SortBy.isActive,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.check_circle_sharp,
                                      color: filtersProvider.sortBy ==
                                              SortBy.isActive
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    'Sort by Active Status',
                                    style: TextStyle(
                                      color: filtersProvider.sortBy ==
                                              SortBy.isActive
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<SortBy>(
                              value: SortBy.playersCount,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.people_sharp,
                                      color: filtersProvider.sortBy ==
                                              SortBy.playersCount
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    'Sort by Number of Online Players',
                                    style: TextStyle(
                                      color: filtersProvider.sortBy ==
                                              SortBy.playersCount
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<SortBy>(
                              value: SortBy.questionsCount,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.question_mark_sharp,
                                      color: filtersProvider.sortBy ==
                                              SortBy.questionsCount
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    'Sort by Number of Questions',
                                    style: TextStyle(
                                      color: filtersProvider.sortBy ==
                                              SortBy.questionsCount
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<SortBy>(
                              value: SortBy.timePerQuestion,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.timer_sharp,
                                      color: filtersProvider.sortBy ==
                                              SortBy.timePerQuestion
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    'Sort by Time Per Question',
                                    style: TextStyle(
                                      color: filtersProvider.sortBy ==
                                              SortBy.timePerQuestion
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            filtersProvider.resetFilters();
                          });
                        },
                        child: IconButton(
                          onPressed: () async {
                            await launchFilterSheet(
                                context, filtersProvider, screenSizeProvider);
                          },
                          icon: Icon(
                            Icons.tune_sharp,
                            color: filtersProvider.doesFiltering()
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: roomsProvider.filteredRooms.isNotEmpty
                ? ListView.builder(
                    itemCount: roomsProvider.filteredRooms.length,
                    itemBuilder: (context, index) {
                      final room = roomsProvider.filteredRooms[index];
                      return RoomCard(
                        room: room,
                        blinkingController: _blinkingController,
                      );
                    },
                  )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.do_not_disturb,
                        size: 64,
                      ),
                      Text("No available rooms found",
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
