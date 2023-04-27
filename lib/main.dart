import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());

  // FirebaseFirestore.instance.collection("col").doc("doc").set({"number":1});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      _currentUser = user;
    })
  }

  Future<FirebaseUser> _getUser() async {
    if (_currentUser != null)
      return _currentUser;

    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
      );

      final AuthResult authResult = await FirebaseAuth.instance.SignInWithCredential(credential);

      final FirebaseUser user = authResult.user;

      return user;
    }
    catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
    );
  }
}

