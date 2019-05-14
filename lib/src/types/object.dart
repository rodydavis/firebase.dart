part of firestore_api;

abstract class FirestoreObject {
  TeslaClient get client;
  Map<String, dynamic> get json;
}