import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Objects/room.dart';
import 'providers/rooms_provider.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final roomsProvider = Provider.of<RoomsProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: roomsProvider.rooms.length,
        itemBuilder: (context, index) {
          final room = roomsProvider.rooms[index];
          return RoomCard(room);
        },
      ),
    );
  }
}

class RoomCard extends StatefulWidget {
  final Room room;

  const RoomCard(this.room, {Key? key}) : super(key: key);

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            initiallyExpanded: widget.room.isExpanded,
            collapsedIconColor: onSurfaceColor,
            iconColor: onSurfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            leading: Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                color: widget.room.isActive ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            title: Text(widget.room.name),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.group_outlined, size: 16),
                SizedBox(width: 4),
                Text('${widget.room.maxPlayers}'),

                SizedBox(width: 12),

                Icon(Icons.question_mark, size: 16),
                SizedBox(width: 4),
                Text('${widget.room.questionsCount}'),

                SizedBox(width: 12),

                Icon(Icons.timer_outlined, size: 16),
                SizedBox(width: 4),
                Text('${widget.room.timePerQuestion}'),

                SizedBox(width: 12),

                Icon(Icons.groups, size: 16),
                SizedBox(width: 4),
                Text('${widget.room.players.length}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.room.isActive
                    ? IconButton(
                        icon: Icon(Icons.login, color: onSurfaceColor),
                        onPressed: () {},
                      )
                    : SizedBox(),
                SizedBox(width: 12),
                Icon(
                  widget.room.isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: onSurfaceColor,
                ),
              ],
            ),
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.room.players.length,
                itemBuilder: (context, index) {
                  final player = widget.room.players[index];
                  return ListTile(
                    title: Text(player),
                  );
                }
              )
            ],
            onExpansionChanged: (isExpanded) {
              setState(() {
                widget.room.isExpanded = isExpanded;
              });
            },
          ),
        );
      },
    );
  }
}
