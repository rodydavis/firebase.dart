part of firestore_api;

abstract class FirestoreApiEndpoints {
  factory FirestoreApiEndpoints.standard() {
    return new FirestoreStandardApiEndpoints();
  }

  Uri get firestoreUrl;
  Uri getAuthUrl(String apiKey);
  Uri getRefreshUrl(String apiKey);
  bool get enableProxyMode;
}

class FirestoreStandardApiEndpoints implements FirestoreApiEndpoints {
  @override
  final Uri firestoreUrl = Uri.parse(
      "https://firestore.googleapis.com/v1/projects/church-family/databases/(default)/documents/");

  @override
  bool get enableProxyMode => false;

  @override
  Uri getAuthUrl(String apiKey) => Uri.parse(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$apiKey');

  @override
  Uri getRefreshUrl(String apiKey) =>
      Uri.parse('https://securetoken.googleapis.com/v1/token?key=$apiKey');
}
