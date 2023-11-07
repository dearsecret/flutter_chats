import 'dart:convert';

import 'package:chats/utils/alert.dart';
import 'package:chats/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timer_builder/timer_builder.dart';

import '../components/mini_profile.dart';

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

class _PartyDetailState extends State<PartyDetail>
    with SingleTickerProviderStateMixin {
  Map? data;

  late TabController _tabController;
  int selectedIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    getDetailData();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: selectedIndex);
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
      setState(() {
        data?["joined"] = true;
      });
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

  _confirmOpenProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("프로필 공개"),
          content: Text("사용자에게 프로필을 공개합니다."),
          actions: [
            ElevatedButton(
                onPressed: () {
                  // TODO : MAKE REQUEST
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
    );
  }

  _confirmShowProfile({required String created}) async {
    final token = await storage.read(key: "token");
    http.Response response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/v1/meetings/${widget.pk}"),
        headers: {"Authorization": token!, "Content-Type": "Application/json"},
        body: jsonEncode({"created": created}));
    if (response.statusCode == 200) {
      print("yo");
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = DateTime.parse(widget.date).millisecondsSinceEpoch;
    TimeUtil.setLocalMessages();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: SliverAppBar(
                actions: [
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert_outlined),
                    itemBuilder: (context) {
                      return [
                        data?["user"]["is_owner"]
                            ? PopupMenuItem(
                                child: Text("삭제하기"),
                                onTap: () {
                                  deleteParty();
                                },
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
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Column(
                  children: [
                    Hero(
                      tag: widget.index,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        child: widget.image,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                    Divider(
                      thickness: 5,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!data?["user"]["is_owner"] && !data?["joined"])
                              IconButton(
                                  onPressed: () {
                                    _showDialog();
                                  },
                                  icon: Icon(Icons.favorite_border))
                          ],
                        ),
                      ),
                    ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.2),
                        child: Text("${data?["content"]}")),
                  ],
                ),
              ),
              if (data?["joined"] != null && data?["joined"] == true)
                Column(children: [
                  Text("프로필 공개를 요청하였습니다."),
                ]),
              if (data?["user"]["is_owner"] != null &&
                  data?["user"]["is_owner"] == true)
                Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: [Tab(text: "프로필 공개 요청"), Tab(text: "프로필 공개")],
                      labelColor: Colors.black,
                      onTap: (int index) {
                        setState(() {
                          selectedIndex = index;
                          _tabController.animateTo(index);
                        });
                      },
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.3),
                      child: IndexedStack(
                        children: [
                          Visibility(
                            visible: selectedIndex == 0,
                            maintainState: true,
                            child: Column(
                              children: [
                                ...data?["descriptions"].map(
                                  (e) {
                                    return Padding(
                                      padding: EdgeInsets.all(5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black),
                                        onPressed: () {
                                          _confirmOpenProfile();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                child: MiniProfile(
                                                    user: e["user"]),
                                              ),
                                            ),
                                            Icon(Icons.favorite_border)
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: selectedIndex == 1,
                            maintainState: true,
                            child: Text("2"),
                          )
                        ],
                        index: selectedIndex,
                      ),
                    ),
                  ],
                ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.2),
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
