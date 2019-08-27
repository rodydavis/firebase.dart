import 'dart:convert';

import 'package:firebase_rest_api/api.dart';
import 'package:flutter/material.dart';

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
          child: Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder<FirebaseUser>(
                    future: client.getCurrentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        JsonEncoder encoder = new JsonEncoder.withIndent('  ');
                        String prettyprint =
                            encoder.convert(snapshot.data.json);
                        debugPrint(prettyprint);
                        return Center(
                            child: Text(
                          prettyprint,
                        ));
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
              // RaisedButton.icon(
              //   icon: Icon(Icons.people),
              //   label: Text('Get Users'),
              //   onPressed: () => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => UsesExample(client: _client),
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
