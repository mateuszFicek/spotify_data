import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Resources/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Connectors/SongService.dart';
import 'Connectors/UserService.dart';
import 'Models/Artist.dart';
import 'Models/Song.dart';
import 'Models/User.dart';
import 'Resources/CustomShapeClipper.dart';

class TopArtistsScreen extends StatefulWidget {
  final User currentUser;
  TopArtistsScreen({Key key, @required this.currentUser}) : super(key: key);
  @override
  _TopArtistsScreenState createState() => _TopArtistsScreenState();
}

class _TopArtistsScreenState extends State<TopArtistsScreen> {
  var user;
  List<Song> topSongs;
  Song currentSong;
  bool isLoaded = false;
  SongService songService = new SongService();
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return !isLoaded
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [greenFontColor, backgroundColorDarker],
                    begin: Alignment.topLeft,
                    end: FractionalOffset(0.3, 0.2))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 1.5 * statusBarHeight),
                Text(
                  'Your top artists',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                spotifyDataWidget(context),
              ],
            ),
          );
  }

  Widget spotifyDataWidget(BuildContext context) {
    var aspect = MediaQuery.of(context).devicePixelRatio;
    return Container(
      height: MediaQuery.of(context).size.height * 0.825 * (2.375) / (aspect),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: songService.getTopArtists(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ));
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Artist artist = snapshot.data[index];
                      return artistTile(artist);
                    });
              },
            ),
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

  Widget artistTile(Artist artist) {
    return Card(
        color: Colors.white10,
        elevation: 0.0,
        margin: new EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        child: Container(
          decoration: BoxDecoration(color: cardColor),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Image.network(artist.imageURL),
            ),
            title: Text(
              artist.name,
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
            // subtitle:
            //     Text(artist.name, style: TextStyle(color: greenFontColor)),
            // trailing: IconButton(
            //   icon: Icon(Icons.play_arrow, color: greenFontColor, size: 30.0),
            //   onPressed: () {},
            // )
          ),
        ));
  }

  _launchURL(Song song) async {
    var url = song.external_urls;
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
