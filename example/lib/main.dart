import 'package:flutter/material.dart';
import 'package:firestore_api/api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _login() async {
    final _client = FirestoreClient(
      'rody.davis.jr@gmail.com',
      'Rody2019!',
      'AIzaSyAhTLKUpaeOKcb0JD2e9OVKcdPOPRBbCPM',
    );
    await _client.login();
    print('token: ${_client.token.accessToken}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              icon: Icon(Icons.account_circle),
              label: Text('Login'),
              onPressed: _login,
            ),
          ],
        ),
      ),
    );
  }
}
