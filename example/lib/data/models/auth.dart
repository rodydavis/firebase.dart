import 'package:example/creds.dart';
import 'package:firebase_rest_api/api.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  FirebaseUser _user;

  void login(String email, String password) async {
    final client = FirestoreClient(firebaseApp);
    await client.login(
      email,
      password,
    );
  }

  void signUp(String email, String password,
      {String displayName, String photoUrl}) async {
    final client = FirestoreClient(firebaseApp);
    await client.signUp(
      email,
      password,
      displayName: displayName,
      photoUrl: photoUrl,
    );
    
  }

  void logout() async {
    _user = null;
    notifyListeners();
  }

  FirebaseUser get user => _user;

  bool get isAuhorized => _user != null && _user.client.isAuthorized;
}
