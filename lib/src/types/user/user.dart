part of firebase_rest_api;

class FirebaseUser implements FirebaseObject {
  FirebaseUser(this.client, this.json);

  @override
  final FirestoreClient client;

  @override
  final Map<String, dynamic> json;

  String get displayName => json['displayName'];

  String get email => json['email'];

  String get uid => json['idToken'];

  String get localId => json['localId'];

  bool get registered => json['registered'] ?? false;

  List<ProviderInfo> get providerUserInfo {
    if (json['providerUserInfo'] == null) return null;
    return List.from(json['providerUserInfo']).map((i) {
      final _data = i as Map<String, dynamic>;
      return ProviderInfo(_data['providerId'], _data['federatedId']);
    }).toList();
  }

  bool get isAnonymous => email == null || email.isEmpty;
}

class ProviderInfo {
  ProviderInfo(this.providerId, this.federatedId);

  final String providerId, federatedId;
}
