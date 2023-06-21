import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/models/Event.dart';
import 'event_tile.dart';

class FeedHistoryScreen extends StatefulWidget {
  const FeedHistoryScreen({Key? key}) : super(key: key);

  @override
  State<FeedHistoryScreen> createState() => _FeedHistoryScreenState();
}

class _FeedHistoryScreenState extends State<FeedHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        future: FirebaseFirestore.instance.collection("events").get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return EventTile(Event.fromDocument(snapshot.data!.docs[index]));
              }
            );
          }
        },
      ),
    );
  }
}
