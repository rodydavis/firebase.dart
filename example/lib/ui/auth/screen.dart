import 'package:example/ui/home/screen.dart';
import 'package:firebase_rest_api/api.dart';
import 'package:flutter/material.dart';

import '../../creds.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirestoreClient _client;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _username, _password;

  void _setLoding(bool value) {
    if (mounted)
      setState(() {
        _loading = value;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Screen'),
          actions: <Widget>[
            if (_client != null)
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  if (mounted)
                    setState(() {
                      _client = null;
                    });
                },
              )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildLogin(FirestoreClient(firebaseApp)),
        ));
  }

  Widget _buildLogin(FirestoreClient client) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(filled: true, hintText: 'Username'),
                onSaved: (val) => _username = val,
                validator: (val) => val.isEmpty ? 'Username Required' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(filled: true, hintText: 'Password'),
                onSaved: (val) => _password = val,
                validator: (val) => val.isEmpty ? 'Password Required' : null,
                obscureText: true,
              ),
            ),
            Container(height: 50),
            if (!_loading) ...[
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Login'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _setLoding(true);
                        try {
                          await client.login(_username, _password);
                        } catch (e) {
                          print('Error => $e');
                        }
                        _checkClient(client);
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text('SignUp'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _setLoding(true);
                        try {
                          await client.signUp(_username, _password);
                        } catch (e) {
                          print('Error => $e');
                        }
                        _checkClient(client);
                      }
                    },
                  ),
                ],
              ),
              Container(height: 20),
              FlatButton(
                child: Text('Guest Login'),
                onPressed: () async {
                  _setLoding(true);
                  try {
                    await client.loginAnonymously();
                  } catch (e) {
                    print('Error => $e');
                  }
                  _checkClient(client);
                },
              ),
            ],
            if (_loading) ...[CircularProgressIndicator()],
          ],
        ),
      ),
    );
  }

  void _checkClient(FirestoreClient client) {
    try {
      if (mounted && client != null) {
        // print('token: ${client?.token?.accessToken}');
        _client = client;
      }
    } on Exception catch (e) {
      print(e);
    }
    _setLoding(false);
    if (_client != null && _client.isAuthorized) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => HomeScreen(client: _client),
      ));
    }
  }
}
