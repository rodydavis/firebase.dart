library firebase_rest_api.impl.common.http;

import 'dart:async';

import '../../../api.dart';

const String _defaultAppName = "[DEFAULT]";

abstract class FirestoreHttpClient implements FirestoreClient {
  FirestoreHttpClient(this.app, this.token, this.endpoints);

  @override
  final App app;

  @override
  final FirestoreApiEndpoints endpoints;

  @override
  FirestoreAccessToken token;

  bool isCurrentTokenValid(bool refreshable) {
    if (token == null) {
      return false;
    }

    if (refreshable) {
      var now = DateTime.now();
      return token.expiresAt.difference(now).abs().inSeconds >= 60;
    }
    return true;
  }

  @override
  bool get isAuthorized => isCurrentTokenValid(true);

  @override
  Future login(String email, String password) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${app.apiKey}',
      body: {
        "email": email,
        "password": password,
        "returnSecureToken": true,
      },
      extract: null,
      needsToken: false,
    );

    token = FirestoreJsonAccessToken(result, DateTime.now());
    return;
  }

  @override
  Future loginAnonymously() async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${app.apiKey}',
      body: {
        "returnSecureToken": true,
      },
      extract: null,
      needsToken: false,
    );

    token = FirestoreJsonAccessToken(result, DateTime.now());
    return;
  }

  @override
  Future signUp(String email, String password) async {
    var result = await getJsonMap(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${app.apiKey}',
        body: {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
        needsToken: false);

    token = FirestoreJsonAccessToken(result, DateTime.now());
    return;
  }

  @override
  Future<UserProviders> fetchProvidersForEmail(String email) async {
    final _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:createAuthUri?key=${app.apiKey}';
    var result = await getJsonMap(
      _url,
      body: {
        "identifier": email,
        "continueUri": _url,
      },
      extract: null,
      needsToken: false,
    );

    return UserProviders(this, result);
  }

  @override
  Future<String> sendPasswordReset(String email) async {
    final _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=${app.apiKey}';

    var result = await getJsonMap(
      _url,
      body: {
        'requestType': 'PASSWORD_RESET',
        "identifier": email,
      },
      extract: null,
      needsToken: false,
    );

    return result['email'];
  }

  @override
  Future<String> verifyPasswordResetCode(String code) async {
    final _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=${app.apiKey}';

    var result = await getJsonMap(
      _url,
      body: {
        "oobCode": code,
      },
      extract: null,
      needsToken: false,
    );

    return result['email'];
  }

  @override
  Future<String> confirmPasswordReset(String code, String password) async {
    final _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=${app.apiKey}';

    var result = await getJsonMap(
      _url,
      body: {
        "oobCode": code,
        'newPassword': password,
      },
      extract: null,
      needsToken: false,
    );

    return result['email'];
  }

  @override
  Future changeEmailForUser(String id, String email) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${app.apiKey}',
      body: {
        "idToken": id,
        "email": email,
        "returnSecureToken": true,
      },
      extract: null,
      needsToken: false,
    );

    token = FirestoreJsonAccessToken(result, DateTime.now());
    return;
  }

  @override
  Future changePasswordForUser(String id, String password) {
    throw "This platform is not supported.";
  }

  @override
  Future confirmEmailVerification(String code) {
    throw "This platform is not supported.";
  }

  @override
  Future deleteUserAccount(String id) {
    throw "This platform is not supported.";
  }

  @override
  Future getDataForUser(String id) {
    throw "This platform is not supported.";
  }

  @override
  Future linkWithEmailPasswordForUser(
      String id, String email, String password) {
    throw "This platform is not supported.";
  }

  @override
  Future sendEmailVerificationForUser(String id) {
    throw "This platform is not supported.";
  }

  @override
  Future unlinkProvidersForUser(String id, List<String> providers) {
    throw "This platform is not supported.";
  }

  @override
  Future updateProfileForUser(String id,
      {String displayName, String photoUrl}) {
    throw "This platform is not supported.";
  }

  @override
  Future<List<DocumentSnapshot>> listDocumentSnapshots(String path) async {
    var list = <DocumentSnapshot>[];

    var result = await getJsonList("$path", extract: 'documents');

    if (result != null)
      for (var item in result) {
        list.add(new DocumentSnapshot(this, item));
      }

    return list;
  }

  @override
  CollectionReference collection(String path) {
    assert(path != null);
    return CollectionReference(this, path.split('/'));
  }

  @override
  DocumentReference document(String path) {
    assert(path != null);
    return DocumentReference(this, path.split('/'));
  }

  @override
  Future<DocumentSnapshot> getDocumentSnapshot(String path) async {
    final _data = await getJsonMap("$path", extract: null);
    return DocumentSnapshot(this, _asStringKeyedMap(_data));
  }

  Future<Map<String, dynamic>> getJsonMap(
    String url, {
    Map<String, dynamic> body,
    String extract: "response",
    bool standard: true,
    bool needsToken = true,
  }) async {
    return (await sendHttpRequest(
      _apiUrl(url, standard),
      body: body,
      extract: extract,
      needsToken: needsToken,
    )) as Map<String, dynamic>;
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
    path = standard ? "$path" : path;
    var uri = endpoints.getFirestoreUrl(app).resolve(path);
    return uri;
  }
}

Map<String, dynamic> _asStringKeyedMap(Map<dynamic, dynamic> map) {
  if (map == null) return null;
  if (map is Map<String, dynamic>) {
    return map;
  } else {
    return Map<String, dynamic>.from(map);
  }
}
