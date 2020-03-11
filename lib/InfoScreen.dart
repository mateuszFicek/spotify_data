import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Connectors/PlaylistService.dart';
import 'package:spotifydata/Models/Playlist.dart';
import 'package:spotifydata/Resources/CustomShapeClipper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Connectors/SongService.dart';
import 'Connectors/UserService.dart';
import 'Models/Song.dart';
import 'Models/User.dart';
import 'Resources/Colors.dart';

class InfoScreen extends StatefulWidget {
  final User currentUser;
  InfoScreen({Key key, @required this.currentUser}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final key = new GlobalKey<ScaffoldState>();

  var user;
  List<Song> topSongs;
  List<Playlist> playlists;
  Song currentSong;
  bool isLoaded = false;
  bool isDataLoaded = false;
  SongService songService = new SongService();
  PlaylistService playlistService = new PlaylistService();
  Playlist chosenPlaylist;
  String selectedName;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCurrentData();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: key,
      body: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [greenFontColor, backgroundColorDarker],
                begin: Alignment.topLeft,
                end: FractionalOffset(0.3, 0.2))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: statusBarHeight,
            ),
            showUserData(),
            SizedBox(height: 20),
            showData(),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return TextStyle(color: Colors.white, fontSize: 16);
  }

  Widget showUserData() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                widget.currentUser.displayName,
                style: textStyle(),
              ),
              Text(
                widget.currentUser.id,
                style: textStyle(),
              )
            ],
          ),
          SizedBox(width: 20),
          Container(
            height: 60,
            width: 60,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: Image.network(widget.currentUser.images)),
          ),
        ],
      ),
    );
  }

  Widget showData() {
    var aspect = MediaQuery.of(context).devicePixelRatio;

    return !isDataLoaded
        ? Container()
        : Container(
            height:
                MediaQuery.of(context).size.height * 0.75 * (2.375) / (aspect),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Now playing ',
                        style: textStyle(),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      currentSong.name == null
                          ? Text(
                              'Start listening...',
                              style: textStyle(),
                            )
                          : songTile(currentSong),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Add current song to playlist', style: textStyle()),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: new Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: backgroundColorDarker,
                        ),
                        child: dropdownPlaylistMenu()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: greenFontColor,
                        ),
                        width: 60,
                        height: 60,
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            var x;
                            if (chosenPlaylist == null)
                              x = "Choose your playlist";
                            else if (currentSong == null)
                              x = "Start listening ";
                            else
                              x = await songService.addSongToPlaylist(
                                  currentSong, chosenPlaylist);

                            _showToast(context, x);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
    playlists = await playlistService.getAllPlaylists();
    setState(() {
      isDataLoaded = true;
    });
  }

  Widget songTile(Song song) {
    return Card(
        color: Colors.white10,
        elevation: 0.0,
        margin: new EdgeInsets.symmetric(vertical: 6.0),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(song.artists + " - " + song.albumName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: greenFontColor)),
              trailing: IconButton(
                icon: Icon(Icons.play_arrow, color: greenFontColor, size: 30.0),
                onPressed: () {
                  _launchURL(song);
                },
              )),
        ));
  }

  Widget dropdownPlaylistMenu() {
    return new DropdownButton(
      isExpanded: true,
      value: chosenPlaylist,
      hint: Text('Choose playlist to add song to',
          style: TextStyle(color: Colors.white)),
      onChanged: (newValue) {
        setState(() {
          chosenPlaylist = newValue;
        });
      },
      items: playlists.map((Playlist playlist) {
        return new DropdownMenuItem<Playlist>(
          value: playlist,
          child: new Container(
            color: Colors.black,
            child: Text(
              playlist.name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(),
    );
  }

  _launchURL(Song song) async {
    var url = song.external_urls;
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(msg),
      ),
    );
  }
}
