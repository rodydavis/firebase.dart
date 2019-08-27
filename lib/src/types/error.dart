// {
//   "error": {
//     "errors": [
//       {
//         "domain": "global",
//         "reason": "invalid",
//         "message": "CREDENTIAL_TOO_OLD_LOGIN_AGAIN"
//       }
//     ],
//     "code": 400,
//     "message": "CREDENTIAL_TOO_OLD_LOGIN_AGAIN"
//   }
// }
part of firebase_rest_api;

class FirebaseError implements FirebaseObject {
  FirebaseError(this.client, this.json);

  @override
  final FirestoreClient client;

  @override
  final Map<String, dynamic> json;
}
