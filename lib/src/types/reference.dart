part of firebase_rest_api;

abstract class FirestoreReference {
  FirestoreClient get client;
  List<String> get pathComponents;
}
