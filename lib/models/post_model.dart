class PostModel {
  int pk;
  String title;
  String content;
  String? image;
  int views;
  bool is_favorite;
  int likes;
  int dislikes;
  String created_at;
  // List comments;
  bool? prefer;
  Map writer;

  PostModel({
    required this.pk,
    required this.is_favorite,
    required this.title,
    required this.content,
    required this.views,
    required this.image,
    required this.writer,
    required this.likes,
    required this.dislikes,
    required this.created_at,
    // required this.comments,
    required this.prefer,
  });

  factory PostModel.fromData(Object? value) {
    Map values = value as Map;
    // List comments = values["comments"] != null
    //     ? List.from(values["comments"].map((e) => e))
    //     : [];
    // print(values);
    return PostModel(
      prefer: values["prefer"],
      pk: values["pk"],
      title: values["title"],
      content: values["content"],
      image: values["image"],
      views: values["views"],
      is_favorite: values["is_favorite"],

      likes: values["likes"],
      dislikes: values["dislikes"],
      created_at: values["created_at"],
      // comments: comments,
      writer: values["writer"],
    );
  }
}


// prefer: true, pk: 2, title: The first time, content: nnbn, 
// image: null, views: 0, is_favorite: false, count_likes: 1, 
// count_dislikes: 0, created_at: 2023-12-04T16:31:44.366400+09:00,