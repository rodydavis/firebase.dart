part of firestore_api;

class DocumentSnapshot implements FirestoreObject {
  DocumentSnapshot(this.client, this.json);

  /// Reads individual values from the snapshot
  dynamic operator [](String key) => json[key];

  @override
  final FirestoreClient client;

  @override
  final Map<String, dynamic> json;

  /// Gets a [DocumentReference] for the specified Firestore path.
  DocumentReference get reference {
    assert(path != null);
    return DocumentReference(client, path.split('/'));
  }

  /// Returns the ID of the snapshot's document
  String get documentID => path.split('/').last;

  /// Returns `true` if the document exists.
  bool get exists => json != null;

  String get path => json['name'];

  DateTime get dateCreate => json['createTime'];

  DateTime get dateUpdated => json['updateTime'];

  Map<String, dynamic> get data {
    Map<String, dynamic> _data = {};
    final Map<String, dynamic> _fields = json['fields'];
    for (var f in _fields.keys) {
      final _item = _fields[f];
      _data['$f'] = _item['stringValue'];
    }
    return _data;
  }
}
