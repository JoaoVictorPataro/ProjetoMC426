import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_neighborhood/event_screen.dart';
import 'package:safe_neighborhood/main.dart';
import 'package:safe_neighborhood/models/Event.dart';
import 'package:safe_neighborhood/models/event_model.dart';

class SimpleMap extends StatefulWidget {
  const SimpleMap({Key? key}) : super(key: key);

  @override
  SimpleMapState createState() => SimpleMapState();
}

class SimpleMapState extends State<SimpleMap> {
  static const LatLng _kMapCenter =
       LatLng(-22.9064, -47.0616); // exemplo: Campinas

  static const CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 15.0, tilt: 0, bearing: 0);

  late GoogleMapController _controller;

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
  }

  void _currentLocation() async {
    Position currentLocation;

    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(bearing: 0, target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 15.0),
    ));
  }

  Set<Circle> circleList = {};
  Set<Marker> markerList = {};

  Future<void> _loadData() async {
    int i = 0;
    for (var element in (await EventModel.getData())) {
        Event e = Event.fromDocument(element);

        circleList.add(Circle(
          circleId: CircleId(i.toString()),
          center: LatLng(e.location.latitude, e.location.longitude),
          radius: 600,
          fillColor: const Color.fromARGB(25, 255, 0, 0),
          strokeWidth: 0
        ));

        markerList.add(Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(e.location.latitude, e.location.longitude),
          infoWindow: InfoWindow(title: e.description),

          onTap: (){
            navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => EventScreen(e)));
          }
        ));

        i += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FutureBuilder(
          future: _loadData(),
          builder: (context, snapshot) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kInitialPosition,
              onMapCreated: onMapCreated,
              myLocationEnabled: true,
              markers: Set<Marker>.of(markerList),
              circles:  Set<Circle>.of(circleList),
            );
          },
        ),
        Align(
          alignment: Alignment.topRight,
          // add your floating action button
          child: Padding (
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: _currentLocation,
              label: const Text('Ir para minha localização'),
            ),
          ),
        ),
      ],
    );
  }
}