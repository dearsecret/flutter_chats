import 'dart:convert';
import 'package:chats/models/post_model.dart';
import 'package:chats/utils/time.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:timer_builder/timer_builder.dart';
import '../utils/alert.dart';

class PostDetail extends StatefulWidget {
  int pk;
  String title;
  PostDetail({super.key, required int this.pk, required String this.title});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  Map? data;
  String comment = "";
  PostModel? detail;
  TextEditingController _textEditingController = TextEditingController();
  final FocusNode unitCodeCtrlFocus = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _detailPage(widget.pk);
    super.initState();
  }

  _detailPage(int pk) async {
    print("get Data");
    final token = await FlutterSecureStorage().read(key: "token");
    http.Response resp = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/v1/chats/chat/$pk"),
        headers: {"Authorization": token!, "Content-Type": "Application/json"});
    if (resp.statusCode == 200) {
      data = jsonDecode(utf8.decode(resp.bodyBytes));
      data!["comments"].map((e) => CommentModel.fromData(e));
      setState(() {
        detail = PostModel.fromData(data);
        favorite = detail!.is_favorite;
      });
    }
  }

  _writeComment(
      {required int pk, required String content, int? selected_comment}) async {
    print("send comment");
    final token = await FlutterSecureStorage().read(key: "token");
    Map<String, dynamic> data = {
      "content": content,
    };
    if (selected_comment != null) {
      data["parent"] = selected_comment;
    }
    http.Response resp = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/v1/chats/chat/$pk/comment"),
        body: jsonEncode(data),
        headers: {"Authorization": token!, "Content-Type": "Application/json"});

    if (resp.statusCode == 200) {
      data = jsonDecode(utf8.decode(resp.bodyBytes));
      print(data);
      if (data["parent"] == null) {
        detail!.comments.add(data);
      } else {
        final id = detail!.comments
            .indexWhere((element) => data["parent"] == element["pk"]);
        detail!.comments[id]["replies"].add(data);
      }
    }
  }

  _toggleFavorite(int pk) async {
    final token = await storage.read(key: "token");
    http.Response resp = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/v1/favorites/$pk"),
        headers: {"Authorization": token!, "Content-Type": "Application/json"});
    if (resp.statusCode == 200) {
      data = jsonDecode(utf8.decode(resp.bodyBytes));
      setState(() {
        favorite = data!["favorite"];
        print(favorite);
      });
    }
  }

  //TODO: SET VOTE API
  bool? _selectedVote = null;
  _toggleVote(int pk) async {
    final token = await storage.read(key: "token");
    http.Response response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/v1/chats/prefer/$pk"),
      body: jsonEncode({"vote": _selectedVote}),
      headers: {"Authorization": token!, "Content-Type": "Application/json"},
    );
    if (response.statusCode == 200) {
      data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data);
      setState(() {
        detail!.prefer = data!["prefer"];
        detail!.count_likes = data!["count_likes"];
        detail!.count_dislikes = data!["count_dislikes"];
      });
    } else {
      print("!!");
    }
  }

  bool favorite = false;
  int? selected_comment;

  // _writefile() async {
  //   final pickedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   http.MultipartRequest request =
  //       await http.MultipartRequest("POST", Uri.parse(""))
  //         ..fields[""]
  //         ..files.add(await MultipartFile.fromPath("file", pickedImage!.path));
  //   http.StreamedResponse response = await request.send();
  //   jsonDecode(utf8.decode(await response.stream.toBytes()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              actions: [
                IconButton(
                  onPressed: () {
                    _toggleFavorite(widget.pk);
                  },
                  icon: favorite
                      ? Icon(Icons.bookmark)
                      : Icon(
                          Icons.bookmark_add_outlined,
                        ),
                ),
                PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem(child: Text("신고하기")),
                          PopupMenuItem(child: Text("취소"))
                        ]),
                DropdownButton<String>(
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white,
                  ),
                  underline: SizedBox.shrink(),
                  elevation: 16,
                  onChanged: (String? value) {
                    if (value == "삭제하기") {
                      showConfirm(context, widget.pk);
                    } else {
                      showAlert(context, widget.pk);
                    }
                  },
                  items: detail == null
                      ? null
                      : [
                          if (detail != null)
                            detail!.is_owner ? "삭제하기" : "신고하기",
                          "취소"
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                )
              ],
            ),
          ];
        },
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                selected_comment = null;
              });
            },
            child: detail == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                constraints: BoxConstraints(minHeight: 500),
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${detail!.title}",
                                          maxLines: null,
                                          style: TextStyle(
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("gender ${detail!.gender}"),
                                      Text("조회수 ${detail!.views}"),
                                    ],
                                  ),
                                  Text("content ${detail!.content}"),
                                  if (detail!.image != null)
                                    AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: ExtendedImage.network(
                                          detail!.image!,
                                          cache: true,
                                        ).image)),
                                      ),
                                    )
                                ]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _selectedVote = true;
                                        _toggleVote(widget.pk);
                                      },
                                      child: Column(
                                        children: [
                                          detail!.prefer == null ||
                                                  detail!.prefer == false
                                              ? Icon(
                                                  Icons.thumb_up_alt_outlined)
                                              : Icon(
                                                  Icons.thumb_up_alt,
                                                  color: Colors.red,
                                                ),
                                          Text("${detail!.count_likes}"),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _selectedVote = false;
                                        _toggleVote(widget.pk);
                                      },
                                      child: Column(
                                        children: [
                                          detail!.prefer == null ||
                                                  detail!.prefer == true
                                              ? Icon(
                                                  Icons.thumb_down_alt_outlined)
                                              : Icon(
                                                  Icons.thumb_down_alt,
                                                  color: Colors.blue,
                                                ),
                                          Text("${detail!.count_dislikes}"),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 10,
                                color: Colors.grey[200],
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text("${detail!.count_comment}"),
                                    if (detail!.comments.isNotEmpty)
                                      ...detail!.comments.map((e) => Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Text(
                                                          "${e["content"]}"),
                                                      subtitle: Row(
                                                        children: [
                                                          TimerBuilder.periodic(
                                                            Duration(
                                                                seconds: 3),
                                                            builder: (context) {
                                                              return Text(
                                                                  "${TimeUtil.timeAgo(milliseconds: DateTime.parse(e["created_at"]).millisecondsSinceEpoch)}");
                                                            },
                                                          ),
                                                          TextButton(
                                                              onPressed: () {
                                                                unitCodeCtrlFocus
                                                                    .requestFocus();
                                                                setState(() {
                                                                  selected_comment =
                                                                      e["pk"];
                                                                });
                                                              },
                                                              child:
                                                                  Text("댓글달기")),
                                                          if (!e["is_owner"])
                                                            TextButton(
                                                                onPressed:
                                                                    () {},
                                                                child: Text(
                                                                    "신고하기")),
                                                        ],
                                                      ),
                                                      trailing: e["is_owner"]
                                                          ? IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(Icons
                                                                  .delete_sweep_outlined))
                                                          : null,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              if (e["replies"] != null)
                                                ...e["replies"].map((e) =>
                                                    ListTile(
                                                      leading: Icon(Icons
                                                          .subdirectory_arrow_right_outlined),
                                                      title: Text(
                                                          "${e["content"]}"),
                                                      subtitle: Row(
                                                        children: [
                                                          TimerBuilder.periodic(
                                                            Duration(
                                                                seconds: 3),
                                                            builder: (context) {
                                                              return Text(
                                                                  "${TimeUtil.timeAgo(milliseconds: DateTime.parse(e["created_at"]).millisecondsSinceEpoch)}");
                                                            },
                                                          ),
                                                          if (!e["is_owner"])
                                                            TextButton(
                                                                onPressed:
                                                                    () {},
                                                                child: Text(
                                                                    "신고하기")),
                                                        ],
                                                      ),
                                                      trailing: e["is_owner"]
                                                          ? IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(Icons
                                                                  .delete_sweep_outlined))
                                                          : null,
                                                    ))
                                            ],
                                          )),
                                    SizedBox(
                                      height: 700,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        color: Colors.white,
                        child: SafeArea(
                          top: false,
                          maintainBottomViewPadding: true,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  if (selected_comment != null)
                                    Text("$selected_comment 에게..")
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.add_a_photo_outlined)),
                                  Expanded(
                                    child: TextField(
                                      controller: _textEditingController,
                                      focusNode: unitCodeCtrlFocus,
                                      onChanged: (value) {
                                        comment = value;
                                      },
                                      decoration:
                                          InputDecoration(hintText: "댓글 남기기"),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _writeComment(
                                            pk: widget.pk,
                                            content: comment,
                                            selected_comment: selected_comment);
                                        _textEditingController.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                      icon: Icon(Icons.arrow_upward))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
