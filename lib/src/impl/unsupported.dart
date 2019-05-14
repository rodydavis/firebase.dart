library firestore_api.impl.unsupported;

import 'dart:async';

import '../../api.dart';

class FirestoreClientImpl implements FirestoreClient {
  FirestoreClientImpl(String email, String password, String apiKey,
      FirestoreAccessToken token, FirestoreApiEndpoints endpoints) {
    throw "This platform is not supported.";
  }

  @override
  String get email => throw "This platform is not supported.";

  @override
  String get password => throw "This platform is not supported.";

  @override
  FirestoreAccessToken get token => throw "This platform is not supported.";

  @override
  set token(FirestoreAccessToken token) =>
      throw "This platform is not supported.";

  @override
  bool get isAuthorized => throw "This platform is not supported.";

  @override
  FirestoreApiEndpoints get endpoints =>
      throw "This platform is not supported.";

  @override
  Future<Document> getDocument(int id) {
    throw "This platform is not supported.";
  }

  @override
  Future<List<Document>> listDocuments(String path) {
    throw "This platform is not supported.";
  }

  @override
  Future<Collection> getCollection(int id) {
    throw "This platform is not supported.";
  }

  @override
  Future<List<Collection>> listCollection(String path) {
    throw "This platform is not supported.";
  }

  @override
  Future login() {
    throw "This platform is not supported.";
  }

  @override
  Future close() {
    throw "This platform is not supported.";
  }

  @override
  String get apiKey => throw "This platform is not supported.";
}
