class Playlist {
  String id;
  String name;

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
  }

  Playlist.fromJsonM(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
  }
}
