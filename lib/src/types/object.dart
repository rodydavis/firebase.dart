part of firebase_rest_api;

abstract class FirebaseObject {
  FirestoreClient get client;
  Map<String, dynamic> get json;
}