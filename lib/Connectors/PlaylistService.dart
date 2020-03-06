import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifydata/Connectors/UserService.dart';
import 'package:spotifydata/Models/User.dart';

class PlaylistService {
  PlaylistService() {}

  Future<void> getAllPlaylists(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final id = user.id;
    final url = "https://api.spotify.com/v1/users/$id/playlists";
    final token = sharedPreferences.get('token');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
  }
}
