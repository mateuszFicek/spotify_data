import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Models/Song.dart';

class SongService {
  SongService();

  Future<Song> getCurrentSong() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final url = "https://api.spotify.com/v1/me/player/currently-playing";
    final token = sharedPreferences.get('token');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    Map songMap = jsonDecode(response.body.toString());

    Song song = Song.fromJson(songMap);
    return song;
  }

  Future<List<Song>> getTopSongs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final url = "https://api.spotify.com/v1/me/top/tracks";
    final token = sharedPreferences.get('token');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    List<Song> topSongs = [];
    Map songMap = jsonDecode(response.body.toString());
    var songs = songMap['items'];
    for (var song in songs) {
      Song cSong = Song.fromJsonList(song);
      topSongs.add(cSong);
    }
    return topSongs;
  }

  Future<void> getTopArtists() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final url = "https://api.spotify.com/v1/me/top/artists";
    final token = sharedPreferences.get('token');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
  }
}
