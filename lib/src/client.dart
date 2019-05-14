part of firestore_api;

abstract class TeslaClient {
  factory TeslaClient(String email, String password,
      {TeslaApiEndpoints endpoints, TeslaAccessToken token}) {
    return new TeslaClientImpl(email, password, token,
        endpoints == null ? new TeslaApiEndpoints.standard() : endpoints);
  }

  String get email;
  String get password;

  TeslaAccessToken get token;
  set token(TeslaAccessToken token);

  bool get isAuthorized;

  TeslaApiEndpoints get endpoints;

  Future login();

  Future<List<Vehicle>> listVehicles();
  Future<Vehicle> getVehicle(int id);

  Future sendVehicleCommand(int id, String command,
      {Map<String, dynamic> params});
  Future<Vehicle> wake(int id);

  Future close();
}
