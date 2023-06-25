import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_neighborhood/home_screen.dart';
import 'package:safe_neighborhood/map.dart';
import 'main.dart';
import 'package:intl/intl.dart';
import 'package:safe_neighborhood/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterEventScreen extends StatefulWidget {
  const RegisterEventScreen({Key? key}) : super(key: key);

  @override
  State<RegisterEventScreen> createState() => _RegisterEventScreenState();
}

class _RegisterEventScreenState extends State<RegisterEventScreen> {
  final docs = FirebaseFirestore.instance;

  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final _types = ["Roubo", "Furto"];
  String _currentSelectedValue = "Roubo";
  DateTime _dateTime = DateTime.now();

  final Set<Marker> _markers = {};
  GeoPoint? _gp;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: const Text(
            'Cadastrar Ocorrência',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 16.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Descrição",
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 200,
                      validator: (text) {
                        if (text == "") return "Adicione uma descrição";
                      },
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    DateTimeFormField(
                      dateTextStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      use24hFormat: true,
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      dateFormat: DateFormat('dd/MM/yyyy - HH:mm'),
                      initialValue: DateTime.now(),
                      onDateSelected: (DateTime date) {
                        _dateTime = date;
                      },
                    ),
                    const SizedBox(
                      height: 48.0,
                    ),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                              hintText: 'Please select expense',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                          isEmpty: _currentSelectedValue == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _currentSelectedValue,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _currentSelectedValue = newValue!;
                                  state.didChange(newValue);
                                });
                              },
                              items: _types.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 28.0,
                    ),
                    SizedBox(
                      height: 300.0,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(target: LatLng(-22.9064, -47.0616), zoom: 15.0, tilt: 0, bearing: 0),
                        myLocationEnabled: true,
                        onTap: (LatLng latLng) {
                          _gp = GeoPoint(latLng.latitude, latLng.longitude);
                          _markers.add(Marker(markerId: MarkerId('mark'), position: latLng));
                          setState(() {});
                        },
                        markers: Set<Marker>.of(_markers),
                      ),
                    ),
                    const SizedBox(
                      height: 28.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: ElevatedButton(
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            if (_gp == null) {
                              _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                                content: Text("Selecione uma localização no mapa",
                                  style: TextStyle(
                                      color: Colors.black
                                  ),),
                                backgroundColor: Colors.yellow,
                                duration: Duration(seconds: 3),
                              ));
                            }
                            else {
                              if (model.isLoggedIn()) {
                                try {
                                  docs.collection('events').add({
                                    "description": _descriptionController.text,
                                    "type": _currentSelectedValue,
                                    "user": docs.collection('users').doc(
                                        model.firebaseUser?.uid ?? ""),
                                    "date-time": _dateTime,
                                    "location": _gp,
                                  });
                                  _onSuccess();
                                } catch (error) {
                                  _onFail();
                                }
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ],
                )
              )
            );
          },
        ),
      ),
    );
  }

  void _onSuccess() async {
    _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(content: Text("Ocorrência cadastrada com sucesso!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),)
    );
    await Future.delayed(const Duration(seconds: 2));
    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _onFail() {
    _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(content: Text("Erro ao cadastrar ocorrência!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),)
    );
  }
}
