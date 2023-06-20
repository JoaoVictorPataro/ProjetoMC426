import 'package:flutter/material.dart';
import 'package:safe_neighborhood/login_screen.dart';
import 'package:safe_neighborhood/models/user_model.dart';
import 'package:safe_neighborhood/register_event_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safe_neighborhood/map.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  // inicializa firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel> (
      model: UserModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Safe Neighborhood',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const RegisterEventScreen(),
      ),
    );
  }
}
