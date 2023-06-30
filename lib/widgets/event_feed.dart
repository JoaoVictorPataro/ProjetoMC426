import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/models/Event.dart';
import 'package:safe_neighborhood/widgets/event_tile.dart';

class EventFeedWidget extends StatefulWidget {
  final Future<QuerySnapshot<Map<String,dynamic>>> events;

  const EventFeedWidget({Key? key, required this.events}) : super(key: key);

  @override
  State<EventFeedWidget> createState() => _EventFeedWidgetState();
}

class _EventFeedWidgetState extends State<EventFeedWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded( child: FutureBuilder<QuerySnapshot> (
            future: widget.events,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        Event e = Event.fromDocument(snapshot.data!.docs[index]);
                          return EventTile(e);
                      }
                  ),
                );
              }
            },
          ));
  }

}