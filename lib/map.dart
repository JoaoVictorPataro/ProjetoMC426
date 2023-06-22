import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
    String v = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    _controller.setMapStyle(v);
  }

  void _currentLocation() async {
    LocationData currentLocation;
    var location = Location();

    currentLocation = await location.getLocation();

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(bearing: 0, target: LatLng(currentLocation.latitude!, currentLocation.longitude!), zoom: 15.0),
    ));
  }

  Set<Marker> _createMarker() {
    return {
      Marker(
        markerId: MarkerId("marker_1"),
        position: _kMapCenter,
        infoWindow: InfoWindow(title: 'Marker 1'),
      ),
      // Marker(
      // markerId: MarkerId('marker_2'),
      //  position: LatLng(18.997962200185533, 72.8379758747611),
      // ),
    };
  }

  Set<Circle> _createCircleAreas() {
    return {
      Circle(
        circleId: CircleId('circle_1'),
        center: _kMapCenter,
        radius: 400,
        fillColor: Color.fromARGB(25, 255, 0, 0)
      ),
    };
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
            markers: _createMarker(),
            circles: _createCircleAreas(),
          ),
          // align it to the bottom center, you can try different options too (e.g topLeft,centerLeft)
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