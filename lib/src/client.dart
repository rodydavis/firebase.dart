part of firestore_api;

abstract class FirestoreClient {
  factory FirestoreClient(String email, String password, String apiKey,
      {FirestoreApiEndpoints endpoints, FirestoreAccessToken token}) {
    return new FirestoreClientImpl(email, password, apiKey, token,
        endpoints == null ? new FirestoreApiEndpoints.standard() : endpoints);
  }

  String get email;
  String get password;
  String get apiKey;

  FirestoreAccessToken get token;
  set token(FirestoreAccessToken token);

  bool get isAuthorized;

  FirestoreApiEndpoints get endpoints;

  Future login();

  Future<List<DocumentSnapshot>> listDocumentSnapshots(String path);
  Future<DocumentSnapshot> getDocumentSnapshot(String path);

  /// Gets a [CollectionReference] for the specified Firestore path.
  CollectionReference collection(String path);

  /// Gets a [DocumentReference] for the specified Firestore path.
  DocumentReference document(String path);

  Future close();
}
