part of firestore_api;

class DocumentSnapshot implements FirestoreObject {
  DocumentSnapshot(this.client, this._path, this.json);

  @override
  final FirestoreClient client;

  @override
  final Map<String, dynamic> json;

  final String _path;

  /// Gets a [DocumentReference] for the specified Firestore path.
  DocumentReference get reference {
    assert(_path != null);
    return DocumentReference(client, _path.split('/'));
  }

  /// Reads individual values from the snapshot
  dynamic operator [](String key) => json[key];

  /// Returns the ID of the snapshot's document
  String get documentID => _path.split('/').last;

  /// Returns `true` if the document exists.
  bool get exists => json != null;
}

