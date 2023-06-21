import 'package:flutter/material.dart';

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
    );
  }
}
