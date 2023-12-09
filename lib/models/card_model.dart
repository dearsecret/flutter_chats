class CardModel {
  final Selected selected;
  final int? evaluate;
  final DateTime created;

  CardModel(
      {required Selected this.selected,
      required int? this.evaluate,
      required DateTime this.created});

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
        selected: Selected.fromJson(json["selected"]),
        evaluate: json["evaluate"] ?? 0,
        created: DateTime.parse(json["created"]).toLocal());
  }
}

class Selected {
  final String name, thumbnail;

  Selected({required String this.name, required String this.thumbnail});

  factory Selected.fromJson(Map<String, dynamic> json) =>
      Selected(name: json["name"], thumbnail: json["thumbnail"]);
}

class PhotoModel {
  late final String url;

  PhotoModel({required String this.url});

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      PhotoModel(url: json['url']);
}

class ProfileModel {
  late final String name;
  late final Map profiles;
  late final List<dynamic> photos;

  ProfileModel({
    required Map this.profiles,
    required List<dynamic> this.photos,
    required String this.name,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    Map profiles = json["profiles"];
    var photos = List.from(json["photos"]?.map((e) => PhotoModel.fromJson(e)));
    return ProfileModel(name: json["name"], profiles: profiles, photos: photos);
  }
}
