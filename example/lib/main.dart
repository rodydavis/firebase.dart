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

const kApiKey = 'AIzaSyAhTLKUpaeOKcb0JD2e9OVKcdPOPRBbCPM'; //'FIREBASE_API_KEY';

class _MyHomePageState extends State<MyHomePage> {
  FirestoreClient _client;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _username, _password;

  void _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _setLoding(true);
      final client = FirestoreClient(_username, _password, kApiKey);
      try {
        await client.login();
        if (mounted && client != null) {
          print('token: ${client?.token?.accessToken}');
          _client = client;
        }
      } on Exception catch (e) {
        print(e);
      }
    }
    _setLoding(false);
  }

  void _setLoding(bool value) {
    if (mounted)
      setState(() {
        _loading = value;
      });
  }

  void _getUsers() async {
    final _path =
        _client.collection('users'); //.document('LLftEJzjYFPbKZuqJDdh');
    print('Data: ${_path.path} ${_path.pathComponents} ${_path.documentID}');
    final _data = await _path.snapshots();
    for (var snapshot in _data) {
      print(snapshot.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (_) {
          if (_client == null || !_client.isAuthorized) {
            return Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration:
                          InputDecoration(filled: true, hintText: 'Username'),
                      onSaved: (val) => _username = val,
                      validator: (val) =>
                          val.isEmpty ? 'Username Required' : null,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(filled: true, hintText: 'Password'),
                      onSaved: (val) => _password = val,
                      validator: (val) =>
                          val.isEmpty ? 'Password Required' : null,
                      obscureText: true,
                    ),
                    RaisedButton.icon(
                      icon: Icon(Icons.account_circle),
                      label: Text('Login'),
                      onPressed: _loading ? null : _login,
                    ),
                    if (_loading) ...[CircularProgressIndicator()],
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton.icon(
                  icon: Icon(Icons.people),
                  label: Text('Get users'),
                  onPressed: _getUsers,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
