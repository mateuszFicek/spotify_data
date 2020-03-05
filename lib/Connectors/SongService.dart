import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SongService {
  SongService() {}

  Future<void> getCurrentSong() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final url = "https://api.spotify.com/v1/me/player/currently-playing";
    final token = sharedPreferences.get('token');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
  }

  Future<void> getTopSongs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final url = "https://api.spotify.com/v1/me/top/tracks";
    final token = sharedPreferences.get('token');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
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
