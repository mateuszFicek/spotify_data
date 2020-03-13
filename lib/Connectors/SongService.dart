import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Models/Artist.dart';
import 'package:spotifydata/Models/Playlist.dart';
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
    var params = {'time_range': 'short_term'};
    final uri = Uri.https('api.spotify.com', '/v1/me/top/tracks', params);
    final token = sharedPreferences.get('token');
    final response = await http.get(uri, headers: {
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

  Future<List<Artist>> getTopArtists() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var params = {'time_range': 'short_term'};
    final uri = Uri.https('api.spotify.com', '/v1/me/top/artists', params);
    final token = sharedPreferences.get('token');
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    List<Artist> topArtists = [];
    Map artistMap = jsonDecode(response.body.toString());
    var artists = artistMap['items'];
    for (var art in artists) {
      Artist cArtist = Artist.fromJson(art);
      topArtists.add(cArtist);
    }
    return topArtists;
  }

  Future<String> addSongToPlaylist(Song song, Playlist playlist) async {
    bool isAlreadyAdded = await checkIfSongIsOnPlaylist(song, playlist);
    if (isAlreadyAdded) return "Song is already on your playlist";
    final sharedPreferences = await SharedPreferences.getInstance();
    final playID = playlist.id;
    final songID = song.id;
    final playlistName = playlist.name;
    var sUri = ["spotify:track:$songID"];
    var songURI = {};
    songURI["uris"] = sUri;
    String jsonBody = json.encode(songURI);
    final uri = Uri.https("api.spotify.com", "/v1/playlists/$playID/tracks");
    final token = sharedPreferences.get('token');
    final response = await http.post(uri, body: jsonBody, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode.toString() == 201.toString()) {
      return "Song was added to $playlistName";
    }
  }

  Future<String> addBatchSongToPlaylist(Playlist playlist) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final playID = playlist.id;
    final playlistName = playlist.name;
    List<Song> songsToAdd = await getTopSongs();
    String uriSongs = "";
    var uris = [];
    for (int i = 0; i < songsToAdd.length; i++) {
      var songId = songsToAdd[i].id;
      uris.add("spotify:track:$songId");
    }
    var songURI = {};
    songURI["uris"] = uris;
    String jsonBody = json.encode(songURI);
    final uri = Uri.https("api.spotify.com", "/v1/playlists/$playID/tracks");
    final token = sharedPreferences.get('token');
    final response = await http.post(uri, body: jsonBody, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode.toString() == 201.toString()) {
      return "Song was added to $playlistName";
    }
  }

  Future<bool> checkIfSongIsOnPlaylist(Song song, Playlist playlist) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final playID = playlist.id;
    final uri = Uri.https("api.spotify.com", "/v1/playlists/$playID/tracks");
    final token = sharedPreferences.get('token');
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    Map songMap = jsonDecode(response.body.toString());
    var songs = songMap['items'];
    for (var i in songs) {
      var current = i['track']['id'];
      if (current == song.id) return true;
    }
    return false;
  }

  Future<List<Artist>> getArtistsRelatedToCurrent(Song song) async {
    List<Artist> related = [];
    final sharedPreferences = await SharedPreferences.getInstance();
    final artistID = song.mainArtistID;
    final uri =
        Uri.https("api.spotify.com", "/v1/artists/$artistID/related-artists");
    final token = sharedPreferences.get('token');
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    Map artistMap = jsonDecode(response.body.toString());
    var artists = artistMap['artists'];
    for (var i in artists) {
      Artist current = Artist.fromJson(i);
      related.add(current);
    }
    return related;
  }

  Future<List<Song>> getSongsRelatedToCurrent(Song song) async {
    List<Song> related = [];
    final sharedPreferences = await SharedPreferences.getInstance();
    var params = {'seed_artists': song.mainArtistID, 'limit': '2'};
    final uri = Uri.https("api.spotify.com", "/v1/recommendations", params);
    final token = sharedPreferences.get('token');
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    Map songMap = jsonDecode(response.body.toString());
    var songs = songMap['tracks'];
    for (var i in songs) {
      Song current = Song.fromJsonList(i);
      related.add(current);
    }
    return related;
  }
}
