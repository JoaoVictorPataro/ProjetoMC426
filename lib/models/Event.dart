import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  late String description;
  late String type;
  late DocumentReference user;
  late DateTime dateTime;
  late GeoPoint location;

  Event();

  Event.fromDocument(String _desc, String _type, DocumentReference _user, DateTime _date, GeoPoint _location) {
    description = _desc;
    type = _type;
    user = _user;
    dateTime = _date;
    location = _location;
  }
}