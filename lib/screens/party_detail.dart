import 'dart:convert';

import 'package:chats/utils/alert.dart';
import 'package:chats/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:http/http.dart' as http;

class PartyDetail extends StatefulWidget {
  late int index, pk;
  late Widget image;
  late String title, date;
  late bool gender;
  PartyDetail(
      {super.key,
      required int this.index,
      required int this.pk,
      required Widget this.image,
      required String this.title,
      required bool this.gender,
      required String this.date});

  @override
  State<PartyDetail> createState() => _PartyDetailState();
}

class _PartyDetailState extends State<PartyDetail> {
  Map? data;
  @override
  void initState() {
    getDetailData();
    // TODO: implement initState
    super.initState();
  }

  getDetailData() async {
    final token = await storage.read(key: "token");
    http.Response response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/v1/meetings/${widget.pk}"),
        headers: {
          "Authorization": token!,
          "Content-Type": "Applications/json"
        });
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(utf8.decode(response.bodyBytes));
      });
      print(data);
    }
  }

  postDescription() async {
    final token = await storage.read(key: "token");
    http.Response response = await http.post(
        Uri.parse(
            "http://127.0.0.1:8000/api/v1/meetings/description/${widget.pk}"),
        headers: {"Authorization": token!, "Content-Type": "Application/json"});
    if (response.statusCode == 200) {
      // TODO : DO SOMETHING
    }
  }

  deleteParty() async {
    final token = await storage.read(key: "token");
    http.Response response = await http.delete(
        Uri.parse("http://127.0.0.1:8000/api/v1/meetings/${widget.pk}"),
        headers: {"Authorization": token!, "Content-Type": "Application/json"});
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    }
  }

  requestDescription() async {
    final token = await storage.read(key: "token");
    http.Response response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/v1/meetings/${widget.pk}"),
        headers: {"Authorization": token!, "Content-Type": "Application/json"});
    if (response.statusCode == 200) {
      print("SUCCESS");
    }
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("프로필 요청"),
            content: Text("상대방에게 프로필 공개를 요청합니다."),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    requestDescription();
                    Navigator.of(context).pop();
                  },
                  child: Text("확인")),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("취소"))
            ],
          );
        },
        barrierDismissible: true);
  }

  @override
  Widget build(BuildContext context) {
    final time = DateTime.parse(widget.date).millisecondsSinceEpoch;
    TimeUtil.setLocalMessages();
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert_outlined),
            itemBuilder: (context) {
              return [
                data?["user"]["is_owner"]
                    ? PopupMenuItem(
                        child: Text("삭제하기"),
                        onTap: () {},
                      )
                    : PopupMenuItem(
                        child: Text("신고하기"),
                        onTap: () {},
                      ),
                PopupMenuItem(child: Text("취소")),
              ];
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Column(
              children: [
                Hero(
                  tag: widget.index,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    child: widget.image,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                Divider(
                  thickness: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: widget.gender
                                ? Colors.blueAccent[100]
                                : Colors.red[200],
                            size: 11,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text("${widget.title}"),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TimerBuilder.periodic(
                          Duration(seconds: 3),
                          builder: (context) {
                            return Text(
                                "${TimeUtil.timeAgo(milliseconds: time)}");
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                if (data == null)
                  CircularProgressIndicator()
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (data?["user"]["is_owner"])
                          IconButton(
                              onPressed: () {
                                deleteParty();
                              },
                              icon: Icon(Icons.delete_forever_outlined))
                        else
                          IconButton(
                              onPressed: () {
                                _showDialog();
                              },
                              icon: Icon(Icons.favorite_border))
                      ],
                    ),
                  ),
                Text("${data?["content"]}"),
                if (data?["description"] != null)
                  ...data?["description"].map((e) => Text("$e"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
