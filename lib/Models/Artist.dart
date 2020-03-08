class Artist {
  var external_urls;
  String id;
  String imageURL;
  String name;

  Artist();

  Artist.fromJson(Map<String, dynamic> json) {
    external_urls = json['external_urls'];
    external_urls = external_urls['spotify'];
    id = json['id'];
    name = json['name'];
    var image = json['images'];
    image = image[1];
    imageURL = image['url'];
  }
}
