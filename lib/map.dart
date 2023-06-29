import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safe_neighborhood/event_screen.dart';
import 'package:safe_neighborhood/main.dart';
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

  Set<Circle> Circles() {
    return {
      Circle(
          circleId: CircleId("circle_1"),
          center: LatLng(-22.9064, -47.0616), // novamente, considerando a latitude e longitude dos eventos ocorridos
          radius: 600,
          fillColor: Color.fromARGB(25, 255, 0, 0)
      ),
      Circle(
          circleId: CircleId("circle_2"),
          center: LatLng(-22.9062, -47.0616), // novamente, considerando a latitude e longitude dos eventos ocorridos
          radius: 600,
          fillColor: Color.fromARGB(25, 255, 0, 0)
      ),
    };
  }

  Set<Marker> Markers() {
    return {
      Marker(
        markerId: MarkerId("1"),
        position: LatLng(-22.9064, -47.0616),
        infoWindow: InfoWindow(title: "Title of my ocurence"),
      ),
      Marker(
        markerId: MarkerId("2"),
        position: LatLng(-22.9062, -47.0616),
      ),
    };
  }

  Set<Circle> circleList = {};
  Set<Marker> markerList = {};

  Future<void> _readFirebaseEventsAndCreateLists() async {
    int i = 0;
    GeoPoint location;
    // inicia instância do Firebase e recupera os dados
    await FirebaseFirestore.instance.collection("events").get().then((querySnapshot) => {
      querySnapshot.docs.forEach((element) {
        // lê eventos do banco de dados e adiciona eles na lista de areas circulares
        location = element.get("location");
        circleList.add(Circle(
            circleId: CircleId(i.toString()),
            center: LatLng(location.latitude, location.longitude), // novamente, considerando a latitude e longitude dos eventos ocorridos
            radius: 600,
            fillColor: Color.fromARGB(25, 255, 0, 0)
        ));

        // ao mesmo tempo, adiciona marcadores na lista de marcadores
        markerList.add(Marker(
            markerId: MarkerId(i.toString()),
            position: LatLng(location.latitude, location.longitude), // novamente, considerando a latitude e longitude dos eventos ocorridos
            infoWindow: InfoWindow(title: element.get("description")),

            onTap: (){

            }
        ));

        // ao final somamos 1 no indice de areas circulares e marcadores
        i += 1;
      })
    });

    //ao final do metodo todos os dados estao carregados nas listas, que serao passadas para o mapa como parametros para que sejam desenhadas no mapa
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FutureBuilder(
          future: _readFirebaseEventsAndCreateLists(),
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