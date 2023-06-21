import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safe_neighborhood/event_screen.dart';
import 'main.dart';
import 'models/Event.dart';

class EventTile extends StatelessWidget {
  final Event event;

  const EventTile(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
                  child: Text(event.type,
                    style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
                  child: Text("${DateFormat("dd/MM/yyyy").format(event.dateTime)}",
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => EventScreen(event)));
      },
    );
  }
}
