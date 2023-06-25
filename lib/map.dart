import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safe_neighborhood/models/Event.dart';

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
    LocationData currentLocation;
    var location = Location();

    currentLocation = await location.getLocation();

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(bearing: 0, target: LatLng(currentLocation.latitude!, currentLocation.longitude!), zoom: 15.0),
    ));
  }

  Set<Circle> circleList = {};
  Set<Marker> markerList = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initialize loadData method
    _loadData();
  }

  void _loadData() async {
    int i = 0;
    FirebaseFirestore.instance.collection("events").get().then((querySnapshot) => {
      querySnapshot.docs.forEach((element) {
        Event e = Event.fromDocument(element);

        circleList.add(Circle(
            circleId: CircleId(i.toString()),
            center: LatLng(e.location.latitude, e.location.longitude),
            radius: 600,
            fillColor: Color.fromARGB(25, 255, 0, 0)
        ));

        markerList.add(Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(e.location.latitude, e.location.longitude),
          infoWindow: InfoWindow(title: e.description),

          onTap: (){

          }
        ));

        i += 1;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kInitialPosition,
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            markers: Set<Marker>.of(markerList),
            circles:  Set<Circle>.of(circleList),
          ),
          Align(
            alignment: Alignment.topRight,
            // add your floating action button
            child: Padding (
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                onPressed: _currentLocation,
                label: Text('Ir para minha localização'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}