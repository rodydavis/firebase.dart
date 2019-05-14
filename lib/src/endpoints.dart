part of firestore_api;

abstract class FirestoreApiEndpoints {
  factory FirestoreApiEndpoints.standard() {
    return new FirestoreStandardApiEndpoints();
  }

  Uri get firestoreUrl;
  String get clientId;
  String get clientSecret;
  bool get enableProxyMode;
}

class FirestoreStandardApiEndpoints implements FirestoreApiEndpoints {
  @override
  final Uri firestoreUrl = Uri.parse("https://firestore.googleapis.com/v1/projects/church-family/databases/(default)/documents/");

  

  @override
  final String clientId =
      "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384";

  @override
  final String clientSecret =
      "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3";

  @override
  bool get enableProxyMode => false;
}
