part of firestore_api;

class Vehicle implements FirestoreObject {
  Vehicle(this.client, this.json);

  @override
  final FirestoreClient client;

  @override
  final Map<String, dynamic> json;

  int get id => json["id"];
  int get vehicleId => json["vehicle_id"];
  String get vin => json["vin"];
  String get displayName => json["display_name"];
  String get rawOptionCodes => json["option_codes"];
  List<String> get optionCodes => rawOptionCodes.split(",");

  String get color => json["color"];
  List<String> get tokens => (json["tokens"] as List)
      .where((it) => it is String)
      .map((it) => it as String)
      .toList();
  String get state => json["state"];
  bool get isInService => json["in_service"];
  String get idString => json["id_s"];
  bool get isCalendarEnabled => json["calendar_enabled"];
  int get apiVersion => json["api_version"];
  String get backseatToken => json["backseat_token"];
  String get backseatTokenUpdatedAt =>
      json["backseat_token_updated_at"].toString();

  Future openChargePort() async {
    // await sendCommand("charge_port_door_open");
  }
}
