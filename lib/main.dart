import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Connectors/UserService.dart';
import 'package:spotifydata/SpotifyDataScreen.dart';

import 'Models/User.dart';
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
  static double bevel = 15.0;
  Offset blurOffset = Offset(bevel / 2, bevel / 2);

  void validateUser() async {
    UserService userService = new UserService();
    userService.authenticateSpotify();
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.get('token') != null) {
      User user = await userService.getUserProfile();
      sharedPreferences.setString('user', user.displayName);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SpotifyDataScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorDarker,
      body: Center(
        child: Container(
          alignment: Alignment(0.0, 0.0),
          height: 300,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: backgroundColorDarker,
              boxShadow: [
                BoxShadow(
                  blurRadius: bevel,
                  offset: -blurOffset,
                  color: backgroundColorDarkerShadow1,
                ),
                BoxShadow(
                    blurRadius: bevel,
                    offset: blurOffset,
                    color: backgroundColorDarkerShadow2)
              ]),
          child: Center(
            child: IconButton(
              iconSize: 150,
              icon: Icon(
                Icons.play_arrow,
              ),
              onPressed: () => validateUser(),
            ),
          ),
        ),
      ),
    );
  }
}
