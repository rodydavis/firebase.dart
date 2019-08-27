library firebase_rest_api.impl.unsupported;

import 'dart:async';

import '../../api.dart';

class FirestoreClientImpl implements FirestoreClient {
  FirestoreClientImpl(
      App app, FirestoreAccessToken token, FirestoreApiEndpoints endpoints) {
    throw "This platform is not supported.";
  }

  @override
  App get app => throw "This platform is not supported.";

  // @override
  // String get email => throw "This platform is not supported.";

  // @override
  // String get password => throw "This platform is not supported.";

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
  Future<DocumentSnapshot> getDocumentSnapshot(String path) {
    throw "This platform is not supported.";
  }

  @override
  Future<List<DocumentSnapshot>> listDocumentSnapshots(String path) {
    throw "This platform is not supported.";
  }

  @override
  Future login(String email, String password) {
    throw "This platform is not supported.";
  }

  @override
  Future close() {
    throw "This platform is not supported.";
  }

  @override
  CollectionReference collection(String path) {
    throw "This platform is not supported.";
  }

  @override
  DocumentReference document(String path) {
    throw "This platform is not supported.";
  }

  @override
  Future loginAnonymously() {
    throw "This platform is not supported.";
  }

  @override
  Future signUp(String email, String password) {
    throw "This platform is not supported.";
  }

  @override
  Future<UserProviders> fetchProvidersForEmail(String email) {
    throw "This platform is not supported.";
  }

  @override
  Future changeEmailForUser(String id, String email) {
    throw "This platform is not supported.";
  }

  @override
  Future changePasswordForUser(String id, String password) {
    throw "This platform is not supported.";
  }

  @override
  Future confirmEmailVerification(String code) {
    throw "This platform is not supported.";
  }

  @override
  Future<String> confirmPasswordReset(String code, String password) {
    throw "This platform is not supported.";
  }

  @override
  Future deleteUserAccount(String id) {
    throw "This platform is not supported.";
  }

  @override
  Future getDataForUser(String id) {
    throw "This platform is not supported.";
  }

  @override
  Future linkWithEmailPasswordForUser(
      String id, String email, String password) {
    throw "This platform is not supported.";
  }

  @override
  Future sendEmailVerificationForUser(String id) {
    throw "This platform is not supported.";
  }

  @override
  Future<String> sendPasswordReset(String email) {
    throw "This platform is not supported.";
  }

  @override
  Future unlinkProvidersForUser(String id, List<String> providers) {
    throw "This platform is not supported.";
  }

  @override
  Future updateProfileForUser(String id,
      {String displayName, String photoUrl}) {
    throw "This platform is not supported.";
  }

  @override
  Future<String> verifyPasswordResetCode(String code) {
    throw "This platform is not supported.";
  }
}
