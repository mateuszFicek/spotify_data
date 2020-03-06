class User {
  String displayName;
  String email;
  String id;
  List<dynamic> images;
  User(this.displayName, this.email, this.id, this.images);

  User.fromJson(Map<String, dynamic> json)
      : displayName = json['display_name'],
        email = json['email'],
        id = json['id'],
        images = json['images'];
}