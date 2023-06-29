import 'package:cloud_firestore/cloud_firestore.dart';
import 'Event.dart';

class EventModel {
  static Future<List<Event>> loadEvents() async {
    List<Event> events = [];

    await FirebaseFirestore.instance.collection("events").get().then((querySnapshot) => {
      querySnapshot.docs.forEach((element) {
        Event e = Event.fromDocument(element);
        events.add(e);
      })
    });

    return events;
  }
  
  static Future<Event> getEventByLocation(GeoPoint location) async {
    Event event = Event();

    await FirebaseFirestore.instance.collection("events").where("location", isEqualTo: location).get().then((value) => {
      event = Event.fromDocument(value.docs[0])
    });

    return event;
  }
}