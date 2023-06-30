import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/models/Event.dart';
import 'package:safe_neighborhood/utils/utils.dart';
import 'package:safe_neighborhood/widgets/event_feed.dart';
import 'models/event_model.dart';
import 'widgets/event_tile.dart';

class FeedHistoryScreen extends StatefulWidget {
  const FeedHistoryScreen({Key? key}) : super(key: key);

  @override
  State<FeedHistoryScreen> createState() => _FeedHistoryScreenState();
}

class _FeedHistoryScreenState extends State<FeedHistoryScreen> {

  final _formKey = GlobalKey<FormState>();
  final indexes = [0, 1, 2, 3, 4];

  String currentTimeItem = FieldUtils.timeLabels[0];
  String currentTypeItem = FieldUtils.typesValues[0];
  double currentRadius = 100.0;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                                        items: FieldUtils.typesValues.map((String value) {
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
                                            value: FieldUtils.timeLabels[value],
                                            child: Text(FieldUtils.timeLabels[value]),
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
          EventFeedWidget(events: EventModel.getFilteredData(currentRadius, currentTimeItem, currentTypeItem))
      ],
    );
  }

}

