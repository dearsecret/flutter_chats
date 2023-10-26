import 'dart:convert';
import 'package:chats/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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
      setState(() {
        data = jsonDecode(resp.body);
        print(data);
        detail = PostModel.fromData(data);
        print(detail);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: false,
              actions: [
                DropdownButton<String>(
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white,
                  ),
                  elevation: 16,
                  onChanged: (String? value) {
                    if (value == "신고하기") {
                      showAlert(context, widget.pk);
                    }
                  },
                  items: ["신고하기", "취소"]
                      .map<DropdownMenuItem<String>>((String value) {
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
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    if (detail!.is_owner)
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete_outline)),
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
                              ]),
                            ),

                            Row(
                              children: [
                                Text("likes ${detail!.count_likes}"),
                                Text("dislikes ${detail!.count_dislikes}"),
                              ],
                            ),
                            Divider(
                              thickness: 10,
                              color: Colors.amber,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text("${detail!.count_comment}"),
                                  if (detail!.comments.isNotEmpty)
                                    ...detail!.comments.map((e) => Row(
                                          children: [Text("$e")],
                                        ))
                                ],
                              ),
                            ),

                            // Text("${detail?.comments}"),
                            SizedBox(
                              height: 300,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Container(
                        width: 500,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.add_a_photo_outlined)),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  comment = value;
                                },
                                decoration: InputDecoration(hintText: "댓글 남기기"),
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_upward))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
