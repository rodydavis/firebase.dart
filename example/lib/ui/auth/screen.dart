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
  bool _signUp = true;
  String _username, _password, _displayName, _photoUrl;

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
            Visibility(
              visible: _signUp,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration:
                      InputDecoration(filled: true, hintText: 'Display Name'),
                  onSaved: (val) => _displayName = val,
                ),
              ),
            ),
            Visibility(
              visible: _signUp,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration:
                      InputDecoration(filled: true, hintText: 'Photo URL'),
                  onSaved: (val) => _photoUrl = val,
                ),
              ),
            ),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: <Widget>[
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
                  RaisedButton(
                    child: _signUp ? Text('Sign Up') : Text('Login'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _setLoding(true);
                        if (_signUp) {
                          try {
                            await client.signUp(
                              _username,
                              _password,
                              displayName: _displayName,
                              photoUrl: _photoUrl,
                            );
                          } catch (e) {
                            print('Error => $e');
                          }
                        } else {
                          try {
                            await client.login(_username, _password);
                          } catch (e) {
                            print('Error => $e');
                          }
                        }
                        _checkClient(client);
                      }
                    },
                  ),
                ],
              ),
              Container(height: 20),
              FlatButton(
                child: Text(_signUp
                    ? 'Already have an account?'
                    : 'Create a new account?'),
                onPressed: () {
                  if (mounted)
                    setState(() {
                      _signUp = !_signUp;
                    });
                },
              ),
              Container(height: 20),
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
