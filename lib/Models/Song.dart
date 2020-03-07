class Song {
  String artists = "";
  var external_urls;
  String id;
  String name;
  String uri;
  String imageURL;

  Song();

  Song.fromJson(Map<String, dynamic> json) {
    var item = json['item'];
    var arts = item['artists'];
    external_urls = item['external_urls'];
    external_urls = external_urls['spotify'];
    id = item['id'];
    name = item['name'];
    uri = item['uri'];
    var counter = 0;
    for (var art in arts) {
      if (counter > 0) artists += ", ";
      if (art['name'] != null) {
        artists += art['name'].toString();
        counter++;
      }
    }
    var album = item['album'];
    var images = album['images'];
  }

  Song.fromJsonList(Map<String, dynamic> json) {
    var arts = json['artists'];
    var counter = 0;

    for (var art in arts) {
      if (counter > 0) artists += ", ";

      if (art['name'] != null) artists += art['name'].toString();
      counter++;
    }
    external_urls = json['external_urls'];
    external_urls = external_urls['spotify'];
    id = json['id'];
    name = json['name'];
    uri = json['uri'];
    var album = json['album'];
    var images = album['images'];
    var image = images[1];
    imageURL = image['url'];
  }
}
