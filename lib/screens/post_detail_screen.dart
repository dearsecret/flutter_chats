import 'package:chats/components/custom_card.dart';
import 'package:chats/models/post_model.dart';
import 'package:chats/providers/post_provider.dart';
import 'package:chats/providers/user_provider.dart';
import 'package:chats/utils/request.dart';
import 'package:chats/utils/time.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class PostDetail extends StatefulWidget {
  late final int pk;
  late final title;
  PostDetail({super.key, required int this.pk, required String this.title});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final FocusNode unitCodeCtrlFocus = FocusNode();
  ValueNotifier<int?> selected_comment = ValueNotifier(null);
  ValueNotifier<int> selected_tab = ValueNotifier(0);
  Map? data;
  PostModel? detail;

  _toggleFavorite(int pk) async {
    await DefaultRequest.get(path: "/favorites/$pk").then((value) {
      setState(() {
        favorite = value!["favorite"];
      });
    });
  }

  bool? _selectedVote = null;
  _toggleVote(int pk) async {
    DefaultRequest.post(
        path: "/chats/prefer/$pk", data: {"vote": _selectedVote}).then((value) {
      setState(() {
        detail!.prefer = data!["prefer"];
        detail!.likes = data!["likes"];
        detail!.dislikes = data!["dislikes"];
      });
    });
  }

  bool favorite = false;

  // int? selected_comment;
  // setUser(int? pk) {
  //   selected_comment = pk;
  // }

  getSelectedUser() {
    return selected_comment.value;
  }

  // TODO: create API exchange Profile card
  // TODO: delete API exchange comment & main text
  // Future _getLikes(category, pk) async {
  //   await DefaultRequest.get(
  //       path: "/services/category=$category&pk=$pk&post=${widget.pk}");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      // body: NestedScrollView(
      //   headerSliverBuilder: (context, innerBoxIsScrolled) {
      //     return [
      //       SliverAppBar(
      //         floating: true,
      //         snap: true,
      //         actions: [
      //           IconButton(
      //             onPressed: () {
      //               _toggleFavorite(widget.pk);
      //             },
      //             icon: favorite
      //                 ? Icon(Icons.bookmark)
      //                 : Icon(
      //                     Icons.bookmark_add_outlined,
      //                   ),
      //           ),
      //           PopupMenuButton(
      //               icon: Icon(
      //                 Icons.more_vert_outlined,
      //               ),
      //               itemBuilder: (context) => [
      //                     PopupMenuItem(child: Text("신고하기")),
      //                     PopupMenuItem(child: Text("취소"))
      //                   ]),
      //         ],
      //       ),
      //     ];
      //   },
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
          selected_comment.value = null;
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: context.read<PostProvider>().getDetialPage(widget.pk),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      var detail = snapshot.data;
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height * 0.7),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${detail?.title}",
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
                                  Text("gender ${detail?.writer["gender"]}"),
                                  Text("조회수 ${detail?.views}"),
                                ],
                              ),
                              Text("content ${detail?.content}"),
                              if (detail?.image != null)
                                AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: ExtendedImage.network(
                                          detail!.image!,
                                          cache: true,
                                        ).image,
                                      ),
                                    ),
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
                                      detail?.prefer == null ||
                                              detail?.prefer == false
                                          ? Icon(Icons.thumb_up_alt_outlined)
                                          : Icon(
                                              Icons.thumb_up_alt,
                                              color: Colors.red,
                                            ),
                                      Text("${detail?.likes}"),
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
                                      detail?.prefer == null ||
                                              detail?.prefer == true
                                          ? Icon(Icons.thumb_down_alt_outlined)
                                          : Icon(
                                              Icons.thumb_down_alt,
                                              color: Colors.blue,
                                            ),
                                      Text("${detail?.dislikes}"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(children: [
                            Divider(
                              thickness: 10,
                              color: Colors.grey[200],
                            ),
                            FutureBuilder(
                              future: !snapshot.hasData
                                  ? null
                                  : Future.delayed(
                                      Duration(milliseconds: 200), () => true),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return CircularProgressIndicator();
                                else
                                  return DefaultTabController(
                                      length: 2,
                                      child: Column(
                                        children: [
                                          TabBar(
                                              onTap: (value) {
                                                selected_tab.value = value;
                                              },
                                              tabs: [
                                                Container(
                                                  child: Text("댓글"),
                                                ),
                                                Container(
                                                  child: Text("프로필 교환"),
                                                )
                                              ]),
                                          ValueListenableBuilder(
                                            valueListenable: selected_tab,
                                            builder: (context, value, child) {
                                              if (value == 0)
                                                return Comment(
                                                    unitCodeCtrlFocus:
                                                        unitCodeCtrlFocus,
                                                    selected_comment:
                                                        selected_comment);
                                              else {
                                                List? cards = context
                                                    .watch<PostProvider>()
                                                    .getExchange;
                                                print(cards);
                                                if (cards != null)
                                                  return GridView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 30),
                                                    shrinkWrap: true,
                                                    itemCount: cards.length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            mainAxisSpacing: 10,
                                                            crossAxisSpacing:
                                                                15,
                                                            childAspectRatio:
                                                                1 / 1.618,
                                                            crossAxisCount: 3),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (cards[index]
                                                              .isEmpty)
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text("상대방의 수락이 필요합니다.")));
                                                        },
                                                        child: CustomCard(
                                                            data: cards[index]
                                                                .cast()),
                                                      );
                                                    },
                                                  );
                                                else
                                                  return Text("nothing");
                                              }
                                            },
                                          )
                                        ],
                                      ));
                              },
                            ),
                            SizedBox(
                              height: 300,
                            )
                          ]),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 15,
                      spreadRadius: 25,
                      color: Colors.grey.shade50,
                      offset: Offset(0, 1))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<int?>(
                    valueListenable: selected_comment,
                    builder: (context, value, child) {
                      return Text("${selected_comment.value ?? "글쓴이"}에게");
                    },
                  ),
                  CustomBottomInput(
                    pk: widget.pk,
                    unitCodeCtrlFocus: unitCodeCtrlFocus,
                    getSelectedUser: getSelectedUser,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}

class Comment extends StatefulWidget {
  const Comment({
    super.key,
    required this.unitCodeCtrlFocus,
    required this.selected_comment,
  });

  final FocusNode unitCodeCtrlFocus;
  final ValueNotifier<int?> selected_comment;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  Future deleteComment(int pk) async {
    return await DefaultRequest.delete(path: "/chats/chat/$pk/comment");
  }

  _showDialog(Map data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("프로필 교환을 요청하시겠습니까?"),
          content: Text("프로필 교환을 요청하면 5포인트가 차감됩니다."),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("취소")),
            ElevatedButton(
                onPressed: () async {
                  await DefaultRequest.get(
                          path: "/services/comment/${data["pk"]}")
                      .then((value) {
                    print(value);
                    if (!(value as Map).containsKey("error"))
                      context.read<PostProvider>().addExchange = value;
                  });
                  Navigator.of(context).pop();
                },
                child: Text("확인"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var comment = context.select<PostProvider, List>((p) => p.getComment);

    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        var comment = provider.getComment;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comment.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: comment[index]["parent"] != null
                  ? Icon(Icons.keyboard_arrow_right)
                  : Text("${comment[index]["pk"]}"),
              title: !comment[index]["is_delete"]
                  ? Text("${comment[index]["content"]}")
                  : Text(
                      "삭제된 댓글입니다.",
                      style: TextStyle(color: Colors.grey),
                    ),
              trailing: comment[index]["author"]["is_owner"]
                  ? (comment[index]["is_delete"]
                      ? null
                      : IconButton(
                          onPressed: () async {
                            await deleteComment(comment[index]["pk"])
                                .then((value) {
                              setState(() {
                                comment[index] = value;
                              });
                            });
                          },
                          icon: Icon(
                            Icons.close,
                          )))
                  : IconButton(
                      onPressed: () {
                        _showDialog(comment[index]);
                      },
                      icon: Icon(Icons.favorite_border)),
              subtitle: Row(
                children: [
                  Text(
                      "${TimeUtil.timeAgo(milliseconds: DateTime.parse(comment[index]["created_at"]).millisecondsSinceEpoch)}"),
                  if (comment[index]["parent"] == null)
                    TextButton(
                      child: Text("댓글달기"),
                      onPressed: () {
                        widget.unitCodeCtrlFocus.requestFocus();
                        widget.selected_comment.value = comment[index]["pk"];
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CustomBottomInput extends StatefulWidget {
  late final int pk;
  late final FocusNode unitCodeCtrlFocus;
  late final Function getSelectedUser;
  CustomBottomInput({
    super.key,
    required int this.pk,
    required FocusNode this.unitCodeCtrlFocus,
    required Function this.getSelectedUser,
  });

  @override
  State<CustomBottomInput> createState() => _CustomBottomInputState();
}

class _CustomBottomInputState extends State<CustomBottomInput> {
  TextEditingController _textEditingController = TextEditingController();

  String comment = "";
  int? to;
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.add_a_photo_outlined)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      // TODO : validate function
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.toString().trim().length < 1) return "ㅜㅜ";
                        return null;
                      },
                      controller: _textEditingController,
                      focusNode: widget.unitCodeCtrlFocus,
                      onChanged: (value) {
                        comment = value;
                      },
                      decoration: InputDecoration(hintText: "댓글 남기기"),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      var to = widget.getSelectedUser();
                      context.read<PostProvider>().writeComment(
                          pk: widget.pk,
                          content: comment,
                          selected_comment: to);
                      _textEditingController.clear();
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(Icons.arrow_upward))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
