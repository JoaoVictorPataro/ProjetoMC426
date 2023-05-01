import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleMap extends StatefulWidget {
  const SimpleMap({Key? key}) : super(key: key);

  @override
  SimpleMapState createState() => SimpleMapState();
}

class SimpleMapState extends State<SimpleMap> {
  static const LatLng _kMapCenter =
       LatLng(-22.9064, -47.0616); // exemplo: Campinas

  static const CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: const GoogleMap(
        initialCameraPosition: _kInitialPosition,
      ),
    );
  }
}