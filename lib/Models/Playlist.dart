class Playlist {
  String id;
  String name;
  String imageUrl;

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    imageUrl = json['images'][0]['url'];
  }
}
