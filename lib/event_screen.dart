import 'package:flutter/material.dart';
import 'package:safe_neighborhood/models/Event.dart';

class EventScreen extends StatelessWidget {
  final Event event;

  const EventScreen(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320.0,
      child: Center(child: Text(event.description),),
    );
  }
}
