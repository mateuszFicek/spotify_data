import 'package:flutter/material.dart';
import 'package:spotifydata/Connectors/SongService.dart';

class SpotifyDataScreen extends StatefulWidget {
  @override
  _SpotifyDataScreenState createState() => _SpotifyDataScreenState();
}

class _SpotifyDataScreenState extends State<SpotifyDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You are in!!!"),
            FlatButton(
              onPressed: _getCurrentSong,
              child: Text("asdas"),
            )
          ],
        ),
      ),
    );
  }

  void _getCurrentSong() {
    SongService songService = new SongService();
    songService.getTopArtists();
  }
}
