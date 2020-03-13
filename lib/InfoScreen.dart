import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Connectors/PlaylistService.dart';
import 'package:spotifydata/Models/Artist.dart';
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
  List<Artist> relatedArtists;
  List<Song> relatedSongs;
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
    var width = MediaQuery.of(context).size.width / 2.25;

    return !isDataLoaded
        ? Container()
        : Expanded(
            // height:
            //     MediaQuery.of(context).size.height * 0.75 * (2.375) / (aspect),
            child: SingleChildScrollView(
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
                          width: 50,
                          height: 50,
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Similar songs and artists",
                        style: textStyle(),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    !isDataLoaded
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () => _launchURL(relatedSongs[0]),
                                child: Container(
                                  height: width,
                                  width: width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  relatedSongs[0].imageURL),
                                              fit: BoxFit.cover)),
                                      child: ClipRRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 0.5, sigmaY: 0.5),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: backgroundColorDarker
                                                .withOpacity(0.5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  relatedSongs[0].name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  relatedSongs[0].artists,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () => _launchURL(relatedSongs[1]),
                                  child: Container(
                                    height: width,
                                    width: width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    relatedSongs[1].imageURL),
                                                fit: BoxFit.cover)),
                                        child: ClipRRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 0.5, sigmaY: 0.5),
                                            child: Container(
                                              alignment: Alignment.center,
                                              color: backgroundColorDarker
                                                  .withOpacity(0.5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    relatedSongs[1].name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    relatedSongs[1].artists,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                    !isDataLoaded
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () => _launchURL(relatedArtists[0]),
                                child: Container(
                                  height: width,
                                  width: width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  relatedArtists[0].imageURL),
                                              fit: BoxFit.cover)),
                                      child: ClipRRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 0.5, sigmaY: 0.5),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: backgroundColorDarker
                                                .withOpacity(0.5),
                                            child: Text(
                                              relatedArtists[0].name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () => _launchURL(relatedArtists[1]),
                                  child: Container(
                                    height: width,
                                    width: width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    relatedArtists[1].imageURL),
                                                fit: BoxFit.cover)),
                                        child: ClipRRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 0.5, sigmaY: 0.5),
                                            child: Container(
                                              alignment: Alignment.center,
                                              color: backgroundColorDarker
                                                  .withOpacity(0.5),
                                              child: Text(
                                                relatedArtists[1].name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 28,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          )
                  ],
                ),
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
    relatedArtists = await songService.getArtistsRelatedToCurrent(currentSong);
    relatedSongs = await songService.getSongsRelatedToCurrent(currentSong);

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

  _launchURL(var toLaunch) async {
    var url = toLaunch.external_urls;
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
