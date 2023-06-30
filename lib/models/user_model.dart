import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final docs = FirebaseFirestore.instance.collection("users");
  User? firebaseUser;
  Map<String, dynamic> userData = {};

  bool isLoading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  DocumentReference<Map<String, dynamic>> getUserReference() {
    return docs.doc(firebaseUser?.uid ?? "");
  } 

  void signUp({required Map<String, dynamic> userData, required String password, required VoidCallback onSuccess, required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: password
    ).then((user) async {
      firebaseUser = user.user;
      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({required String email, required String password, required VoidCallback onSuccess, required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((user) async {
      firebaseUser = user.user;
      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();
    userData = {};
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await docs.doc(firebaseUser?.uid).set(userData);
  }



  Future<void> _loadCurrentUser() async {
    // tenta obter usuario logado no momento
    firebaseUser = await _auth.currentUser;

    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await docs.doc(firebaseUser?.uid).get();
        userData = docUser.data() as Map<String, dynamic>;
      }
    }
    notifyListeners();
  }


}