import 'dart:convert';

import 'package:firebase_rest_api/api.dart';
import 'package:flutter/material.dart';

import 'actions/edit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
    @required this.client,
  }) : super(key: key);

  final FirestoreClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: SafeArea(
        child: Center(
            child: FutureBuilder<FirebaseUser>(
          future: client.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final _user = snapshot.data;
              JsonEncoder encoder = new JsonEncoder.withIndent('  ');
              String prettyprint = encoder.convert(_user.json);
              debugPrint(prettyprint);
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Text(
                      prettyprint,
                    )),
                  ),
                  FlatButton(
                    child: Text('Edit Info'),
                    onPressed: () async {
                      final _valid = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditInfoScreen(user: _user),
                            fullscreenDialog: true,
                          ));
                      if (_valid != null && _valid) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )),
      ),
    );
  }
}
