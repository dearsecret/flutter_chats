class PostModel {
  final String id;
  String title;
  final int timestamp;
  int views;

  PostModel(this.id, this.title, this.timestamp, this.views);
  factory PostModel.fromData(String? key, Object? value) {
    Map values = value as Map;
    int views = values.containsKey("views") ? values["views"] : 0;
    return PostModel(key!, values["title"], values["timestamp"], views);
  }
}
