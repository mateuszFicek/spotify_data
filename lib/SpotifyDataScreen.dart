import 'package:flutter/material.dart';
import 'package:spotifydata/Connectors/SongService.dart';
import 'package:spotifydata/Connectors/UserService.dart';
import 'package:spotifydata/Models/User.dart';
import 'package:spotifydata/Resources/CustomShapeClipper.dart';

class SpotifyDataScreen extends StatefulWidget {
  @override
  _SpotifyDataScreenState createState() => _SpotifyDataScreenState();
}

class _SpotifyDataScreenState extends State<SpotifyDataScreen> {
  User user;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Witaj',
                              style:
                                  TextStyle(fontSize: 28, color: Colors.grey)),
                          Text(
                            user.displayName,
                            style: TextStyle(color: Colors.white, fontSize: 48),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: <Widget>[],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getUserData() async {
    UserService userService = new UserService();
    user = await userService.getUserProfile();
  }
}
