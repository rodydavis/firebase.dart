part of firebase_rest_api;

class UserProviders implements FirebaseObject {
  UserProviders(this.client, this.json);

  @override
  final FirestoreClient client;

  @override
  final Map<String, dynamic> json;

  List<String> get providers => List.from(json['allProviders']);

  bool get isRegistered => json['registered'];
}
