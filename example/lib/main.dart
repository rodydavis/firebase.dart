import 'package:example/creds.dart';
import 'package:flutter/material.dart';
import 'package:firebase_rest_api/api.dart';

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
        title: Text(widget.title),
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
      body: Builder(
        builder: (_) {
          final client = FirestoreClient(firebaseApp);
          if (_client == null || !_client.isAuthorized) {
            return Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration:
                            InputDecoration(filled: true, hintText: 'Username'),
                        onSaved: (val) => _username = val,
                        validator: (val) =>
                            val.isEmpty ? 'Username Required' : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration:
                            InputDecoration(filled: true, hintText: 'Password'),
                        onSaved: (val) => _password = val,
                        validator: (val) =>
                            val.isEmpty ? 'Password Required' : null,
                        obscureText: true,
                      ),
                    ),
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

          return SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder<FirebaseUser>(
                        future: client.getCurrentUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                                child: Text(
                              snapshot.data.json.toString(),
                            ));
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                  RaisedButton.icon(
                    icon: Icon(Icons.people),
                    label: Text('Get Users'),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UsesExample(client: _client),
                        )),
                  ),
                ],
              ),
            ),
          );
        },
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
  }
}

class UsesExample extends StatefulWidget {
  UsesExample({
    @required this.client,
  });
  final FirestoreClient client;
  @override
  _UsesExampleState createState() => _UsesExampleState();
}

class _UsesExampleState extends State<UsesExample> {
  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  List<DocumentSnapshot> _users;

  void _getUsers() async {
    final _path = widget.client.collection('users');
    print('Data: ${_path.path} ${_path.pathComponents} ${_path.documentID}');
    final _data = await _path.snapshots();

    if (mounted)
      setState(() {
        _users = _data;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: Builder(
        builder: (_) {
          if (_users == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_users.isEmpty) {
            return Center(
              child: Text('No Users Found'),
            );
          }
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (_, index) {
              final _item = _users[index];
              return ListTile(
                title: Text(
                    '${_item?.data['first_name'] ?? ''} ${_item?.data['last_name'] ?? ''}'),
                subtitle: Text(_item.data['email']),
              );
            },
          );
        },
      ),
    );
  }
}
