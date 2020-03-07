import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Connectors/UserService.dart';
import 'package:spotifydata/SpotifyDataScreen.dart';

import 'Resources/Colors.dart';

void main() => runApp(AuthToApp());

class AuthToApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Sen",
      ),
      home: AuthPage(title: 'AuthPage'),
    );
  }
}

class AuthPage extends StatefulWidget {
  AuthPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int _counter = 0;

  void validateUser() async {
    UserService userService = new UserService();
    userService.authenticateSpotify();
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.get('token') != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SpotifyDataScreen()),
      );
    }
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
            Text('Click Button to login with Spotify'),
            RaisedButton(
              onPressed: () => validateUser(),
              child: Text('Sign In'),
              color: spotifyGreen,
            ),
          ],
        ),
      ),
    );
  }
}
