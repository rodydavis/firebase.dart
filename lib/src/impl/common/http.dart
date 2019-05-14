library firestore_api.impl.common.http;

import 'dart:async';

import '../../../api.dart';

abstract class FirestoreHttpClient implements FirestoreClient {
  FirestoreHttpClient(
      this.email, this.password, this.apiKey, this.token, this.endpoints);

  @override
  final String email;

  @override
  final String password;

  @override
  final String apiKey;

  @override
  final FirestoreApiEndpoints endpoints;

  @override
  FirestoreAccessToken token;

  bool isCurrentTokenValid(bool refreshable) {
    if (token == null) {
      return false;
    }

    if (refreshable) {
      var now = new DateTime.now();
      return token.expiresAt.difference(now).abs().inSeconds >= 60;
    }
    return true;
  }

  @override
  bool get isAuthorized => isCurrentTokenValid(true);

  @override
  Future login() async {
    if (!isCurrentTokenValid(false)) {
      var result = await sendHttpRequest(endpoints.getAuthUrl(apiKey),
          body: {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
          needsToken: false);

      token = new FirestoreJsonAccessToken(result);
      return;
    }

    var result = await sendHttpRequest(endpoints.getRefreshUrl(apiKey),
        body: {
          "grant_type": "refresh_token",
          "refresh_token": token.refreshToken
        },
        needsToken: false);

    token = new FirestoreJsonAccessToken(result);
  }

  @override
  Future<List<Document>> listDocuments(String path) async {
    var vehicles = <Document>[];

    var result = await getJsonList("vehicles");

    for (var item in result) {
      vehicles.add(new Document(this, item));
    }

    return vehicles;
  }

  @override
  Future<Document> getDocument(int id) async {
    return new Document(this, await getJsonMap("vehicles/${id}"));
  }

  @override
  Future<List<Collection>> listCollection(String path) async {
    var vehicles = <Collection>[];

    var result = await getJsonList("vehicles");

    for (var item in result) {
      vehicles.add(new Collection(this, item));
    }

    return vehicles;
  }

  @override
  Future<Collection> getCollection(int id) async {
    return new Collection(this, await getJsonMap("vehicles/${id}"));
  }

  Future<Map<String, dynamic>> getJsonMap(String url,
      {Map<String, dynamic> body,
      String extract: "response",
      bool standard: true}) async {
    return (await sendHttpRequest(_apiUrl(url, standard),
        body: body, extract: extract)) as Map<String, dynamic>;
  }

  Future<List<dynamic>> getJsonList(String url,
      {Map<String, dynamic> body,
      String extract: "response",
      bool standard: true}) async {
    return (await sendHttpRequest(_apiUrl(url, standard),
        body: body, extract: extract)) as List<dynamic>;
  }

  Future<dynamic> sendHttpRequest(Uri uri,
      {bool needsToken: true, String extract, Map<String, dynamic> body});

  Uri _apiUrl(String path, bool standard) {
    path = standard ? "/api/1/${path}" : path;
    var uri = endpoints.firestoreUrl.resolve(path);
    return uri;
  }
}
