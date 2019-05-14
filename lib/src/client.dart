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

  Future<List<Document>> listDocuments(String path);
  Future<Document> getDocument(int id);

  Future<List<Collection>> listCollection(String path);
  Future<Collection> getCollection(int id);

  Future close();
}
