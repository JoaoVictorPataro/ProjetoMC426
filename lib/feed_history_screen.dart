import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/models/Event.dart';
import 'widgets/event_tile.dart';

class FeedHistoryScreen extends StatefulWidget {
  const FeedHistoryScreen({Key? key}) : super(key: key);

  @override
  State<FeedHistoryScreen> createState() => _FeedHistoryScreenState();
}

class _FeedHistoryScreenState extends State<FeedHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        title: const Text(
          'Feed',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot> (
        future: FirebaseFirestore.instance.collection("events").orderBy("date-time", descending: true).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
              child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return EventTile(Event.fromDocument(snapshot.data!.docs[index]));
                  }
              ),
            );
          }
        },
      ),
    );
  }
}
