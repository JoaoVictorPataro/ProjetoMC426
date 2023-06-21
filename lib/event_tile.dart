import 'package:flutter/material.dart';
import 'package:safe_neighborhood/event_screen.dart';
import 'main.dart';
import 'models/Event.dart';

class EventTile extends StatelessWidget {
  final Event event;

  const EventTile(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Column(
          children: [
            Text(event.description),
            Text(event.type),
            Text(event.dateTime.toString()),
            Text("${event.location.latitude} ${event.location.longitude}"),
          ],
        ),
      ),
      onTap: () {
        navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => EventScreen(event)));
      },
    );
  }
}
