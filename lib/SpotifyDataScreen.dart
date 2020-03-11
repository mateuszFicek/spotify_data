import 'package:flutter/material.dart';
import 'package:spotifydata/Connectors/SongService.dart';
import 'package:spotifydata/Connectors/UserService.dart';
import 'package:spotifydata/InfoScreen.dart';
import 'package:spotifydata/Models/Song.dart';
import 'package:spotifydata/Models/User.dart';
import 'package:spotifydata/Resources/Colors.dart';
import 'package:spotifydata/Resources/CustomShapeClipper.dart';
import 'package:spotifydata/TopArtistsScreen.dart';
import 'package:spotifydata/TopSongsScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyDataScreen extends StatefulWidget {
  final User currentUser;

  SpotifyDataScreen({Key key, @required this.currentUser}) : super(key: key);

  @override
  _SpotifyDataScreenState createState() => _SpotifyDataScreenState();
}

class _SpotifyDataScreenState extends State<SpotifyDataScreen> {
  var user;
  List<Song> topSongs;
  Song currentSong;
  bool isLoaded = true;
  int _selectedIndex = 0;

  SongService songService = new SongService();
  @override
  void initState() {
    super.initState();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Songs',
      style: optionStyle,
    ),
    Text('Index 2: Artists')
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundWhite,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: backgroundColorLighter,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              title: Text('Songs'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Artists'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: greenFontColor,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
        body: !isLoaded
            ? Center(child: CircularProgressIndicator())
            : [
                InfoScreen(
                  currentUser: widget.currentUser,
                ),
                TopSongsScreen(
                  currentUser: widget.currentUser,
                ),
                TopArtistsScreen(
                  currentUser: widget.currentUser,
                )
              ].elementAt(_selectedIndex));
  }
}
