import 'package:firebase_rest_api/api.dart';
import 'package:flutter/material.dart';

class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({Key key, @required this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  TextEditingController _name, _image;

  @override
  void initState() {
    _name = TextEditingController(text: widget?.user?.displayName);
    _image = TextEditingController(text: widget?.user?.photoUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Info'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: _name,
              decoration: InputDecoration(hintText: 'Display Name'),
            ),
          ),
          ListTile(
            title: TextField(
              controller: _image,
              decoration: InputDecoration(hintText: 'Photo URL'),
            ),
          ),
          ListTile(
            title: RaisedButton(
              child: Text('Save Info'),
              onPressed: () {
                widget.user.client.updateProfileForUser(
                  displayName: _name.text,
                  photoUrl: _image.text,
                );
                Navigator.pop(context, true);
              },
            ),
          )
        ],
      ),
    );
  }
}
