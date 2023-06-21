import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  late String description;
  late String type;
  late DocumentReference user;
  late DateTime dateTime;
  late GeoPoint location;

  Event.fromDocument(QueryDocumentSnapshot snapshot) {
    description = snapshot.get("description");
    type = snapshot.get("type");
    user = snapshot.get("user");
    dateTime = snapshot.get("date-time").toDate();
    location = snapshot.get("location");
  }
}