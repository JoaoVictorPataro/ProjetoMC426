import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/Event.dart';

class MapWidget extends StatefulWidget {
  final List<Event> events;

  const MapWidget({Key? key, required this.events}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Set<Circle> circleList = {};
  Set<Marker> markerList = {};

  late LatLng _mapCenter;
  late CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();
    // initialize loadData method
    _loadEvents();

    if (widget.events != []) {
      _mapCenter = LatLng(widget.events[0].location.latitude, widget.events[0].location.longitude);
    }
    else {
      _mapCenter = const LatLng(-22.9064, -47.0616);
    }
    _initialPosition = CameraPosition(target: _mapCenter, zoom: 15.0, tilt: 0, bearing: 0);
  }

  void _loadEvents() {
    int i = 0;
    for (var e in widget.events) {
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

          }
      ));

      i += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialPosition,
      myLocationEnabled: true,
      markers: Set<Marker>.of(markerList),
      circles:  Set<Circle>.of(circleList),
    );
  }
}
