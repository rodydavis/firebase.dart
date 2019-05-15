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
  FirestoreClient _client;
  void _login() async {
    final client = FirestoreClient(
      'rody.davis.jr@gmail.com',
      'Rody2019!',
      'AIzaSyAhTLKUpaeOKcb0JD2e9OVKcdPOPRBbCPM',
    );
    await client.login();
    try {
      if (mounted && client != null) {
        print('token: ${client?.token?.accessToken}');
        setState(() {
          _client = client;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _getUsers() async {
    final _data = await _client.document('users/LLftEJzjYFPbKZuqJDdh').get();
    print('Data: ${_data.json}');
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
            if (_client != null) ...[
              RaisedButton.icon(
                icon: Icon(Icons.people),
                label: Text('Get users'),
                onPressed: _getUsers,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
