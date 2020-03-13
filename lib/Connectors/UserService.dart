import 'dart:convert';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Models/User.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';

class UserService {
  final clientID = "1e3423ef3dab4d67ab75bdf308b8b951";
  final callbackUrl = "spotifydata";
  User user;
  UserService();

  Future<void> authenticateSpotify() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final url = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'token',
      'client_id': clientID,
      'redirect_uri': 'spotifydata://callback',
      'scope':
          'user-read-private user-read-email user-read-currently-playing user-top-read playlist-modify-public playlist-modify-private',
    });
    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: callbackUrl);
    final token = Uri.parse(result);
    String at = token.fragment;
    at = "http://website/index.html?$at";
    var accesstoken = Uri.parse(at).queryParameters['access_token'];
    sharedPreferences.setString('token', accesstoken);
  }

  Future<User> getUserProfile() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final url = "https://api.spotify.com/v1/me";
    final token = sharedPreferences.get('token');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    Map userMap = jsonDecode(response.body.toString());
    return User.fromJson(userMap);
  }
}
