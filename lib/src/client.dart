part of firebase_rest_api;

abstract class FirestoreClient {
  factory FirestoreClient(App app,
      {FirestoreApiEndpoints endpoints, FirestoreAccessToken token}) {
    return new FirestoreClientImpl(app, token,
        endpoints == null ? new FirestoreApiEndpoints.standard() : endpoints);
  }

  App get app;

  FirestoreAccessToken get token;
  set token(FirestoreAccessToken token);

  bool get isAuthorized;

  FirestoreApiEndpoints get endpoints;

  Future login(String email, String password);

  Future signUp(String email, String password);

  Future loginAnonymously();

  Future<UserProviders> fetchProvidersForEmail(String email);

  Future<String> sendPasswordReset(String email);

  Future<String> verifyPasswordResetCode(String code);

  Future<String> confirmPasswordReset(String code, String password);

  Future sendEmailVerificationForUser(String id);

  Future confirmEmailVerification(String code);

  Future changeEmailForUser(String id, String email);

  Future changePasswordForUser(String id, String password);

  Future updateProfileForUser(String id, {String displayName, String photoUrl});

  Future unlinkProvidersForUser(String id, List<String> providers);

  Future getDataForUser(String id);

  Future deleteUserAccount(String id);

  Future linkWithEmailPasswordForUser(String id, String email, String password);

  Future<List<DocumentSnapshot>> listDocumentSnapshots(String path);
  Future<DocumentSnapshot> getDocumentSnapshot(String path);

  /// Gets a [CollectionReference] for the specified Firestore path.
  CollectionReference collection(String path);

  /// Gets a [DocumentReference] for the specified Firestore path.
  DocumentReference document(String path);

  Future close();
}

const String _defaultAppName = "default";

class App {
  /// Creates (and initializes) a Firebase App with API key, auth domain,
  /// database URL and storage bucket.
  ///
  /// See: <https://firebase.google.com/docs/reference/js/firebase#.initializeApp>.
  const App({
    this.apiKey,
    this.authDomain,
    this.databaseURL,
    this.projectId,
    this.storageBucket,
    this.messagingSenderId,
    this.appId,
    String database,
  })  : _name = database,
        assert(apiKey != null),
        assert(projectId != null);

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      apiKey: json['apiKey'],
      authDomain: json['authDomain'],
      databaseURL: json['databaseURL'],
      projectId: json['projectId'],
      storageBucket: json['storageBucket'],
      messagingSenderId: json['messagingSenderId'],
      appId: json['appId'],
    );
  }
  final String apiKey;
  final String authDomain;
  final String databaseURL;
  final String projectId;
  final String storageBucket;
  final String messagingSenderId;
  final String appId;

  /// Database Override [DEFAULT]
  String get name => _name ?? _defaultAppName;
  final String _name;
}
