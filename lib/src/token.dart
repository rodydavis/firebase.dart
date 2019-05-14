part of firestore_api;

abstract class FirestoreAccessToken {
  String get accessToken;
  String get refreshToken;
  DateTime get createdAt;
  DateTime get expiresAt;

  bool get isExpired => expiresAt.isAfter(new DateTime.now());
}

class FirestoreJsonAccessToken extends FirestoreAccessToken {
  FirestoreJsonAccessToken(this.json);

  final Map<String, dynamic> json;
  String get displayName => json['displayName'] as String;
  String get email => json['email'] as String;
  String get kind => json['kind'] as String;
  String get localId => json['localId'] as String;
  bool get registered => json['registered'] as bool;
  int get expiresInSeconds => json["expires_in"] as int;
  int get createdAtEpochSeconds => json["created_at"] as int;

  @override
  String get accessToken => json["idToken"] as String;

  @override
  String get refreshToken => json["refresh_token"] as String;

  @override
  DateTime get createdAt =>
      new DateTime.fromMillisecondsSinceEpoch(createdAtEpochSeconds * 1000);

  @override
  DateTime get expiresAt =>
      createdAt.add(new Duration(seconds: expiresInSeconds));
}
