import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  final clientID = "1e3423ef3dab4d67ab75bdf308b8b951";
  final callbackUrl = "spotifydata";

  void _authenticateSpotify() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final url = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'token',
      'client_id': clientID,
      'redirect_uri': 'spotifydata://callback',
      'scope':
          'user-read-private user-read-currently-playing user-top-read playlist-modify-public playlist-modify-private',
    });
    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: callbackUrl);
    final token = Uri.parse(result);
    String at = token.fragment;
    at = "http://website/index.html?$at";
    var accesstoken = Uri.parse(at).queryParameters['access_token'];
    print(accesstoken);
    sharedPreferences.setString('token', accesstoken);
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
              onPressed: () => _authenticateSpotify(),
              child: Text('Sign In'),
              color: spotifyGreen,
            ),
          ],
        ),
      ),
    );
  }
}
