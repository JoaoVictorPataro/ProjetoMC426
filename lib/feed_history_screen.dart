import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/models/Event.dart';
import 'widgets/event_tile.dart';
import 'package:geolocator/geolocator.dart';

class FeedHistoryScreen extends StatefulWidget {
  const FeedHistoryScreen({Key? key}) : super(key: key);

  @override
  State<FeedHistoryScreen> createState() => _FeedHistoryScreenState();
}

class _FeedHistoryScreenState extends State<FeedHistoryScreen> {

  final _formKey = GlobalKey<FormState>();
  final indexes = [0, 1, 2, 3, 4];
  static const timeLabels = ["Qualquer periodo",
    "Madrugada",
    "Manhã",
    "Tarde",
    "Noite"];
  static const typesValues = ["Qualquer Tipo",
  "Roubo",
  "Furto"];

  String currentTimeItem = timeLabels[0];
  String currentTypeItem = typesValues[0];
  double currentRadius = 100.0;

  Query<Map<String,dynamic>> resolveTypeQuery(Query<Map<String,dynamic>> query) {
    if (currentTypeItem != typesValues[0]) {
      return query.where("type", isEqualTo: currentTypeItem);
    } else {
      return query;
    }
  }

  Query<Map<String,dynamic>> resolveTimeQuery(Query<Map<String,dynamic>> query) {
    for (int i = 1; i < 5; i ++) {
      if (currentTimeItem == timeLabels[i]) {
        return query.where("period", isEqualTo: timeLabels[i]);
      }
    }
    return query;
  }

  Query<Map<String,dynamic>> resolveDistanceQuery(Query<Map<String,dynamic>> query,
    Position position)  {
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

  Future<QuerySnapshot<Map<String,dynamic>>> getData() async{
    Position position = await Geolocator
    .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    Query<Map<String,dynamic>> query = FirebaseFirestore.instance.collection("events")
    .limit(currentRadius.round());
    query = resolveTypeQuery(query);
    query = resolveDistanceQuery(query, position);
    query = resolveTimeQuery(query);
    return query.get();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: false,
      physics: const NeverScrollableScrollPhysics(),
      children: [
          const SizedBox(height: 10),
          Container( 
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(const Size(150, 10))
                ),
              child: const Text("Filtros"),
              onPressed: () {
                showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                    return Form(
                      key: _formKey,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          const SizedBox(
                                height: 14.0,
                              ),
                          FormField <String> (
                            builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                    decoration: InputDecoration(
                                        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                    isEmpty: currentTypeItem == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: currentTypeItem,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            currentTypeItem = newValue!;
                                            state.didChange(newValue);
                                          });
                                        },
                                        items: typesValues.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                              }
                            ),
                          const SizedBox(
                                height: 28.0,
                              ),
                          FormField <String> (
                            builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                    decoration: InputDecoration(
                                        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                    isEmpty: currentTimeItem == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: currentTimeItem,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            currentTimeItem = newValue!;
                                            state.didChange(newValue);
                                          });
                                        },
                                        items: indexes.map((int value) {
                                          return DropdownMenuItem<String>(
                                            value: timeLabels[value],
                                            child: Text(timeLabels[value]),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                              }
                            ),
                          const SizedBox(
                                height: 14.0,
                              ),
                          const Center(
                            child: Text("Raio:", style: TextStyle(fontSize: 20),)
                            ),
                          FormField <double>(
                            builder: (FormFieldState<double> state) {
                              return Slider(
                                  value: currentRadius,
                                  min: 100,
                                  max: 5000.0,
                                  divisions: 49,
                                  label: "${currentRadius.round()}m",
                                  onChanged: (value) {
                                    setState(() {
                                      currentRadius = value.round().toDouble();
                                      state.didChange(value);
                                    });
                                  }
                                );
                            }
                          ),
                          const SizedBox(
                                height: 14.0,
                              ),
                        ]
                      )
                    );
                  }
                );
              },
            )
          ),
          const Divider(
            height: 10,
            thickness: 1,
            color: Colors.black,
          ),
          FutureBuilder<QuerySnapshot> (
            future: getData(),
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
          )
      ],
    );
  }

}

