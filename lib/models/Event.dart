import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  late String description;
  late String type;
  late DocumentReference user;
  late DateTime dateTime;
  late GeoPoint location;
  late String period;

  Event.fromData(this.description, this.type, this.user,
    this.dateTime, this.location, this.period);

  Event();

  bool checkRange(DateTimeRange range) {
    if (dateTime.isAtSameMomentAs(range.start) ||
        dateTime.isAfter(range.start) ||
        dateTime.isAtSameMomentAs(range.end) ||
        dateTime.isBefore(range.end)) {
        return true;
      }
    return false;
  }

  Event.fromDocument(QueryDocumentSnapshot snapshot) {
    description = snapshot.get("description");
    type = snapshot.get("type");
    user = snapshot.get("user");
    dateTime = snapshot.get("dateTime").toDate();
    location = snapshot.get("location");
    period = snapshot.get("period");
  }
}