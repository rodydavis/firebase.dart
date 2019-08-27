import '../../api.dart';

class FirebaseUser implements FirebaseObject {
  FirebaseUser(this.client, this.json);

  @override
  final FirestoreClient client;

  @override
  final Map<String, dynamic> json;

  String get displayName => json[''];
  String get email => json[''];
  String get uid => json[''];
}
