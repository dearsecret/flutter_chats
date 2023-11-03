class PostModel {
  int pk;
  String title;
  String content;
  int views;
  bool is_owner;
  bool is_favorite;
  String gender;
  int count_comment;
  int count_likes;
  int count_dislikes;
  String created_at;
  String? image;
  List comments;
  bool? prefer;

  PostModel({
    required this.pk,
    required this.is_favorite,
    required this.title,
    required this.content,
    required this.views,
    required this.image,
    required this.is_owner,
    required this.gender,
    required this.count_comment,
    required this.count_likes,
    required this.count_dislikes,
    required this.created_at,
    required this.comments,
    required this.prefer,
  });

  factory PostModel.fromData(Object? value) {
    Map values = value as Map;
    List comments = values["comments"] != null
        ? List.from(values["comments"].map((e) => e))
        : [];
    return PostModel(
      pk: values["pk"],
      prefer: values["prefer"],
      is_favorite: values["is_favorite"],
      title: values["title"],
      created_at: values["created_at"],
      views: values["views"],
      image: values["image"],
      content: values["content"],
      count_likes: values["count_likes"],
      count_dislikes: values["count_dislikes"],
      is_owner: values["is_owner"],
      gender: values["gender"],
      count_comment: values["count_comment"],
      comments: comments,
    );
  }
}

class CommentModel {
  late final int pk;
  late final bool is_owner;
  late final bool is_writer;
  late final String created_at;
  String? gender;
  String? content;
  int? parent;
  List replies = [];

  CommentModel({
    required int pk,
    required String content,
    String? gender,
    int? parent,
    required bool is_owner,
    required bool is_writer,
    required String created_at,
    required List replies,
  });

  factory CommentModel.fromData(Map value) {
    final replies = [
      value["replies"]?.map((e) {
        return CommentModel.fromData(e);
      })
    ];

    return CommentModel(
        pk: value["pk"],
        gender: value["gender"],
        content: value["content"],
        is_owner: value["is_owner"],
        is_writer: value["is_writer"],
        created_at: value["created_at"],
        parent: value["parent"],
        replies: replies);
  }
}
