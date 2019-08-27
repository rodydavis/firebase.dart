part of firebase_rest_api;

abstract class FirestoreAccessToken {
  String get accessToken;

  String get refreshToken;

  DateTime get createdAt;

  DateTime get expiresAt;

  bool get isExpired => expiresAt.isAfter(new DateTime.now());
}

class FirestoreJsonAccessToken extends FirestoreAccessToken {
  FirestoreJsonAccessToken(this.json, this.createdAt);

  final Map<String, dynamic> json;

  @override
  String get accessToken => json["idToken"] as String;

  @override
  String get refreshToken => json["refresh_token"] as String;

  @override
  final DateTime createdAt;

  @override
  DateTime get expiresAt =>
      createdAt.add(new Duration(seconds: expiresInSeconds));

  String get displayName => json['displayName'] as String;

  String get email => json['email'] as String;

  String get kind => json['kind'] as String;

  bool get registered => json['registered'] as bool;

  int get expiresInSeconds => int.tryParse(json["expiresIn"]);

  String get idToken => json['id_token'] as String;

  String get localId => json['localId'] as String;
}
