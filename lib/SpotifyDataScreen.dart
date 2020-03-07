import 'package:flutter/material.dart';
import 'package:spotifydata/Connectors/SongService.dart';
import 'package:spotifydata/Connectors/UserService.dart';
import 'package:spotifydata/Models/Song.dart';
import 'package:spotifydata/Models/User.dart';
import 'package:spotifydata/Resources/Colors.dart';
import 'package:spotifydata/Resources/CustomShapeClipper.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyDataScreen extends StatefulWidget {
  @override
  _SpotifyDataScreenState createState() => _SpotifyDataScreenState();
}

class _SpotifyDataScreenState extends State<SpotifyDataScreen> {
  User user;
  List<Song> topSongs;
  Song currentSong;
  bool isLoaded = false;
  SongService songService = new SongService();
  @override
  void initState() {
    super.initState();
    fetchUserData();
    // fetchSongsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      body: !isLoaded
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  userInfoWidget(),
                  spotifyDataWidget(context),
                ],
              ),
            ),
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
    );
  }

  Widget spotifyDataWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: songService.getTopSongs(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Text('Is loading...'));
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Song song = snapshot.data[index];
                      return songTile(song);
                    });
              },
            ),
          )
        ],
      ),
    );
  }

  void fetchUserData() async {
    UserService userService = new UserService();
    user = await userService.getUserProfile();
    if (user != null)
      setState(() {
        isLoaded = true;
      });
  }

  void fetchSongsData() async {
    SongService songService = new SongService();
    topSongs = await songService.getTopSongs();
    currentSong = await songService.getCurrentSong();
  }

  Widget songTile(Song song) {
    return Card(
        elevation: 8.0,
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
                child: Image.network(song.imageURL),
              ),
              title: Text(
                song.name,
                style: TextStyle(color: fontColor, fontWeight: FontWeight.bold),
              ),
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

              subtitle:
                  Text(song.artists, style: TextStyle(color: greenFontColor)),
              trailing: IconButton(
                icon: Icon(Icons.play_arrow, color: greenFontColor, size: 30.0),
                onPressed: () {
                  print(song.external_urls);
                  _launchURL(song);
                },
              )),
        ));
  }

  Future<List<Song>> getTopSongs() async {
    SongService songService = new SongService();
    return songService.getTopSongs();
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
