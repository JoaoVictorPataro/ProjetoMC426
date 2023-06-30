import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_neighborhood/utils/utils.dart';
import 'Event.dart';

class EventModel {
  static final docs = FirebaseFirestore.instance.collection("events");

  static Future<List<Event>> loadEvents() async {
    List<Event> events = [];

    await docs.get().then((querySnapshot) => {
      querySnapshot.docs.forEach((element) {
        Event e = Event.fromDocument(element);
        events.add(e);
      })
    });

    return events;
  }
  
  static Query<Map<String,dynamic>> resolveTypeQuery(Query<Map<String,dynamic>> query, type) {
    if (type != FieldUtils.typesValues[0]) {
      return query.where("type", isEqualTo: type);
    } else {
      return query;
    }
  }

  static Query<Map<String,dynamic>> resolvePeriodQuery(Query<Map<String,dynamic>> query, String period) {
    for (int i = 1; i < 5; i ++) {
      if (period == FieldUtils.timeLabels[i]) {
        return query.where("period", isEqualTo: FieldUtils.timeLabels[i]);
      }
    }
    return query;
  }

  static Query<Map<String,dynamic>> resolveDistanceQuery(Query<Map<String,dynamic>> query,
    Position position, double currentRadius)  {
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;
    double distance = currentRadius*0.000621371;
    double lowerLat = position.latitude - (lat * distance);
    double lowerLon = position.longitude - (lon * distance);
    double greaterLat = position.latitude + (lat * distance);
    double greaterLon = position.longitude + (lon * distance);
    GeoPoint lesserGeopoint = GeoPoint(lowerLat,lowerLon);
    GeoPoint greaterGeopoint = GeoPoint(greaterLat,greaterLon);
    return query.where("location", isGreaterThanOrEqualTo: lesserGeopoint)
                .where("location", isLessThanOrEqualTo: greaterGeopoint);
  }

  static Future<QuerySnapshot<Map<String,dynamic>>> getFilteredData(double currentRadius, String period, String type) async{
    Position position = await Geolocator
    .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    Query<Map<String,dynamic>> query = docs.limit(currentRadius.round());
    query = resolveTypeQuery(query, type);
    query = resolveDistanceQuery(query, position, currentRadius);
    query = resolvePeriodQuery(query, period);
    return query.get();
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async{
    return (await docs.get()).docs;
  }

  static Future<DocumentReference<Map<String,dynamic>>> saveEvent(Event e) async {
    return await docs.add({
                            "description": e.description,
                            "type": e.type,
                            "user": e.user,
                            "dateTime": e.dateTime,
                            "location": e.location,
                            "period": e.period
                          });
  }

  static Future<Event> getEventByLocation(GeoPoint location) async {
    Event event = Event();

    await FirebaseFirestore.instance.collection("events").where("location", isEqualTo: location).get().then((value) => {
      event = Event.fromDocument(value.docs[0])
    });

    return event;
  }
}