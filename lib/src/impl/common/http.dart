library firestore_api.impl.common.http;

import 'dart:async';

import '../../../api.dart';

abstract class FirestoreHttpClient implements FirestoreClient {
  FirestoreHttpClient(this.email, this.password, this.token, this.endpoints);

  @override
  final String email;

  @override
  final String password;

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
      var result = await sendHttpRequest("/oauth/token",
          body: {
            "grant_type": "password",
            "client_id": endpoints.clientId,
            "client_secret": endpoints.clientSecret,
            "email": email,
            "password": password
          },
          needsToken: false);

      token = new FirestoreJsonAccessToken(result);
      return;
    }

    var result = await sendHttpRequest("/oauth/token",
        body: {
          "grant_type": "refresh_token",
          "client_id": endpoints.clientId,
          "client_secret": endpoints.clientSecret,
          "refresh_token": token.refreshToken
        },
        needsToken: false);

    token = new FirestoreJsonAccessToken(result);
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

  Future<dynamic> sendHttpRequest(String url,
      {bool needsToken: true, String extract, Map<String, dynamic> body});

  String _apiUrl(String path, bool standard) =>
      standard ? "/api/1/${path}" : path;
}
