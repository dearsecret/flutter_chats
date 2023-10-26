class PostModel {
  int pk;
  String title;
  String content;
  int views;
  bool is_owner;
  String gender;
  int count_comment;
  int count_likes;
  int count_dislikes;
  String created_at;
  List comments;

  PostModel({
    required this.pk,
    required this.title,
    required this.content,
    required this.views,
    required this.is_owner,
    required this.gender,
    required this.count_comment,
    required this.count_likes,
    required this.count_dislikes,
    required this.created_at,
    required this.comments,
  });

  factory PostModel.fromData(Object? value) {
    Map values = value as Map;
    List comments = values["comments"] != null
        ? List<CommentModel>.from(values["comments"]
            .map((e) => e == null ? null : CommentModel.fromData(e)))
        : [];
    return PostModel(
      pk: values["pk"],
      title: values["title"],
      created_at: values["created_at"],
      views: values["views"],
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
  final String pk;
  String content;
  final String created_at;
  List<ReplyModel?> replies;

  CommentModel(this.pk, this.content, this.created_at, this.replies);

  factory CommentModel.fromData(Object? value) {
    Map values = value as Map;
    final replies = List<ReplyModel>.from(values["reply"].map((e) {
      return ReplyModel.fromData(e as Map);
    }));
    return CommentModel(
      values["pk"],
      values["content"],
      values["created_at"],
      replies,
    );
  }
}

class ReplyModel {
  final String pk;
  String content;
  final String created_at;

  ReplyModel(this.pk, this.content, this.created_at);

  factory ReplyModel.fromData(Object? value) {
    Map values = value as Map;
    return ReplyModel(values["pk"], values["content"], values["created_at"]);
  }
}
