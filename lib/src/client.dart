part of firestore_api;

abstract class FirestoreClient {
  factory FirestoreClient(String email, String password,
      {FirestoreApiEndpoints endpoints, FirestoreAccessToken token}) {
    return new FirestoreClientImpl(email, password, token,
        endpoints == null ? new FirestoreApiEndpoints.standard() : endpoints);
  }

  String get email;
  String get password;

  FirestoreAccessToken get token;
  set token(FirestoreAccessToken token);

  bool get isAuthorized;

  FirestoreApiEndpoints get endpoints;

  Future login();

  Future<List<Vehicle>> listVehicles();
  Future<Vehicle> getVehicle(int id);

  Future sendVehicleCommand(int id, String command,
      {Map<String, dynamic> params});
  Future<Vehicle> wake(int id);

  Future close();
}
