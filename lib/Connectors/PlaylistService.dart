import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Connectors/UserService.dart';
import 'package:spotifydata/Models/Playlist.dart';
import 'package:spotifydata/Models/User.dart';

class PlaylistService {
  PlaylistService();

  Future<List<Playlist>> getAllPlaylists() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.get('id');
    final url = "https://api.spotify.com/v1/users/$id/playlists?limit=50";
    final token = sharedPreferences.get('token');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    List<Playlist> playlists = [];
    Map playlistMap = json.decode(response.body.toString());
    var play = playlistMap['items'];
    for (var p in play) {
      var ownership = p['owner']['id'];
      if (ownership == id) {
        Playlist cPlaylist = Playlist.fromJson(p);
        playlists.add(cPlaylist);
      }
    }
    var next = playlistMap['next'];
    while (next != null) {
      final token = sharedPreferences.get('token');
      final responseanother = await http.get(next.toString(), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      Map playlistMap = json.decode(responseanother.body.toString());
      next = playlistMap['next'];
      var play = playlistMap['items'];
      for (var p in play) {
        var ownership = p['owner']['id'];
        if (ownership == id) {
          Playlist cPlaylist = Playlist.fromJson(p);
          playlists.add(cPlaylist);
        }
      }
    }
    return playlists;
  }

  Future<Playlist> createPlaylist(String name) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.get('id');
    final url = "https://api.spotify.com/v1/users/$id/playlists";
    final token = sharedPreferences.get('token');
    String json = '{"name": "$name"}';
    final response = await http.post(url, body: json, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    Map playlistMap = jsonDecode(response.body);
    Playlist cPlaylist = Playlist.fromJson(playlistMap);
    print("PLAYLIST ID " + cPlaylist.id);
    return cPlaylist;
  }
}
