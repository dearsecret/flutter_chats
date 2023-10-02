class User {
  PublicUser? user;
  UserInfo? info;

  User([PublicUser? this.user, UserInfo? this.info]);

  set addUser(PublicUser profile) => user = profile;
  set addInfo(UserInfo userInfo) => info = userInfo;
}

class PublicUser {
  final String pk;
  final String name;
  final int points;

  PublicUser({required this.pk, required this.name, required this.points});

  factory PublicUser.fromJson(Map<String, dynamic> json) =>
      PublicUser(pk: json["pk"], name: json["name"], points: json["point"]);
}

class UserInfo {
  String username;
  List<dynamic> photos;

  UserInfo({
    required this.username,
    required this.photos,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : username = json["username"],
        photos = List<String>.from(json["photos"]);
}
