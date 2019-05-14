library firestore_api.impl.unsupported;

import 'dart:async';

import '../../api.dart';

class TeslaClientImpl implements TeslaClient {
  TeslaClientImpl(String email, String password, TeslaAccessToken token,
      TeslaApiEndpoints endpoints) {
    throw "This platform is not supported.";
  }

  @override
  String get email => throw "This platform is not supported.";

  @override
  String get password => throw "This platform is not supported.";

  @override
  TeslaAccessToken get token => throw "This platform is not supported.";

  @override
  set token(TeslaAccessToken token) => throw "This platform is not supported.";

  @override
  bool get isAuthorized => throw "This platform is not supported.";

  @override
  TeslaApiEndpoints get endpoints => throw "This platform is not supported.";

  @override
  Future<Vehicle> getVehicle(int id) {
    throw "This platform is not supported.";
  }

  @override
  Future<List<Vehicle>> listVehicles() {
    throw "This platform is not supported.";
  }

  @override
  Future login() {
    throw "This platform is not supported.";
  }

  @override
  Future sendVehicleCommand(int id, String command,
      {Map<String, dynamic> params}) {
    throw "This platform is not supported.";
  }

  @override
  Future<Vehicle> wake(int id) {
    throw "This platform is not supported.";
  }

  @override
  Future close() {
    throw "This platform is not supported.";
  }
}
