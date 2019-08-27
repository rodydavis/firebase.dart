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

  @override
  Future changeEmailForUser(String idToken, String email) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=${app.apiKey}',
      body: {
        "idToken": idToken,
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
  Future changePasswordForUser(String idToken, String password) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=${app.apiKey}',
      body: {
        "idToken": idToken,
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
  CollectionReference collection(String path) {
    assert(path != null);
    return CollectionReference(this, path.split('/'));
  }

  @override
  Future<String> confirmEmailVerification(String code) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=${app.apiKey}',
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
  Future deleteUserAccount(String id) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=${app.apiKey}',
      body: {
        "idToken": id,
      },
      extract: null,
      needsToken: false,
    );

    return;
  }

  @override
  DocumentReference document(String path) {
    assert(path != null);
    return DocumentReference(this, path.split('/'));
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
  Future<FirebaseUser> getCurrentUser(String idToken) async {
    var result = await getJsonList(
      'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=${app.apiKey}',
      body: {
        "idToken": idToken,
        "returnSecureToken": true,
      },
      extract: 'users',
      needsToken: false,
    );

    if (result != null)
      for (var item in result) {
        final _user = FirebaseUser(this, item, idToken);
        if (_user.uid == token.localId) {
          return _user;
        }
      }
    return null;
  }

  @override
  Future<DocumentSnapshot> getDocumentSnapshot(String path) async {
    final _data = await getJsonMap("$path", extract: null);
    return DocumentSnapshot(this, _asStringKeyedMap(_data));
  }

  @override
  Future<FirebaseUser> getUserInfo(String idToken, String uid) async {
    var result = await getJsonList(
      'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=${app.apiKey}',
      body: {
        "idToken": idToken,
        "returnSecureToken": true,
      },
      extract: 'users',
      needsToken: false,
    );

    if (result != null)
      for (var item in result) {
        final _user = FirebaseUser(this, item, idToken);
        if (_user.uid == uid) {
          return _user;
        }
      }
    return null;
  }

  @override
  Future<List<FirebaseUser>> getUsersForToken(String idToken) async {
    var list = <FirebaseUser>[];

    var result = await getJsonList(
      'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=${app.apiKey}',
      body: {
        "idToken": idToken,
        "returnSecureToken": true,
      },
      extract: 'users',
      needsToken: false,
    );

    if (result != null)
      for (var item in result) {
        list.add(FirebaseUser(this, item, idToken));
      }
    return list;
  }

  @override
  bool get isAuthorized => isCurrentTokenValid(false);

  @override
  Future linkWithEmailPasswordForUser(
      String id, String email, String password) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=${app.apiKey}',
      body: {
        "idToken": id,
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
  Future<String> sendEmailVerificationForUser(String idToken) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=${app.apiKey}',
      body: {
        "idToken": idToken,
        "requestType": 'VERIFY_EMAIL',
      },
      extract: null,
      needsToken: false,
    );
    return result['email'];
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
  Future signUp(String email, String password,
      {String displayName, String photoUrl}) async {
    var result = await getJsonMap(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${app.apiKey}',
        body: {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
        needsToken: false);

    token = FirestoreJsonAccessToken(result, DateTime.now());
    if (displayName != null || photoUrl != null) {
      await updateProfileForUser(token.idToken,
          displayName: displayName, photoUrl: photoUrl);
    }
    return;
  }

  @override
  Future unlinkProvidersForUser(String idToken, List<String> providers) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=${app.apiKey}',
      body: {
        "idToken": idToken,
        "deleteProvider": providers,
      },
      extract: null,
      needsToken: false,
    );
    return;
  }

  @override
  Future updateProfileForUser(String idToken,
      {String displayName, String photoUrl}) async {
    var result = await getJsonMap(
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=${app.apiKey}',
      body: {
        "idToken": idToken,
        if (displayName != null) ...{
          'displayName': displayName,
        },
        if (photoUrl != null) ...{
          'photoUrl': photoUrl,
        },
        "deleteAttribute": [
          if (displayName == null) 'DISPLAY_NAME',
          if (photoUrl == null) 'PHOTO_URL',
        ],
        "returnSecureToken": true,
      },
      extract: null,
      needsToken: false,
    );

    token = FirestoreJsonAccessToken(result, DateTime.now());
    return;
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

  Future<List<dynamic>> getJsonList(
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
    )) as List<dynamic>;
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
