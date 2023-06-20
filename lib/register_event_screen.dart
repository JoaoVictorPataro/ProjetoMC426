import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_location_picker/export.dart';
import 'package:intl/intl.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:flutter_google_location_picker/flutter_google_location_picker.dart';

class RegisterEventScreen extends StatefulWidget {
  const RegisterEventScreen({Key? key}) : super(key: key);

  @override
  State<RegisterEventScreen> createState() => _RegisterEventScreenState();
}

class _RegisterEventScreenState extends State<RegisterEventScreen> {
  final _descriptionController = TextEditingController();
  final _types = ["Roubo", "Furto"];
  String _currentSelectedValue = "Roubo";

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
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
        body: Form(
          child: ListView(
          padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 16.0),
          children: <Widget>[
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
                height: 48.0,
              ),
              /*SizedBox(
                height: 256.0,
                child: FlutterGoogleLocationPicker(
                  center: LatLong(latitude: -22.81770548926072, longitude: -47.06867993916107),
                  onPicked: (pickedData) {
                    print(pickedData.latLong.latitude);
                    print(pickedData.latLong.longitude);
                    print(pickedData.address);
                  },
                ),
              ),*/
            ],
          )
        ),
      ),
    );
  }
}
