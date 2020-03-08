import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Resources/CustomShapeClipper.dart';

import 'Connectors/SongService.dart';
import 'Connectors/UserService.dart';
import 'Models/Song.dart';
import 'Models/User.dart';
import 'Resources/Colors.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  var user;
  List<Song> topSongs;
  Song currentSong;
  bool isLoaded = false;
  bool isDataLoaded = false;
  SongService songService = new SongService();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCurrentData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[userInfoWidget(), showData()],
    );
  }

  Widget userInfoWidget() {
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        color: fontColor,
        height: MediaQuery.of(context).size.height * 0.2,
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
                      style: TextStyle(fontSize: 28, color: greenFontColor)),
                  !isLoaded
                      ? Text('User')
                      : Text(
                          user,
                          style: TextStyle(color: Colors.white, fontSize: 48),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return TextStyle(color: Colors.white, fontSize: 16);
  }

  Widget showData() {
    return !isDataLoaded
        ? Container()
        : Container(
            height: MediaQuery.of(context).size.height * 0.73,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Currently playing : ',
                      style: textStyle(),
                    ),
                    Text(
                      currentSong.name,
                      style: textStyle(),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  void fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    user = sharedPreferences.get('user');
    if (user != null)
      setState(() {
        isLoaded = true;
      });
  }

  void fetchCurrentData() async {
    currentSong = await songService.getCurrentSong();
    setState(() {
      isDataLoaded = true;
    });
  }
}
