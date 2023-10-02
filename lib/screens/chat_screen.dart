import 'package:chats/apis/user_repository.dart';
import 'package:chats/components/chat_list.dart';
import 'package:chats/screens/chat_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late ScrollController _controller;
  var repository = UserRepository();
  int? _initialPk;
  List _myList = [];
  int totalLength = 0;
  bool _isLoading = false;
  bool _hasData = true;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getChatList();
    });
  }

  _getChatList() async {
    _isLoading = true;
    List result = await repository.chatMore(totalLength);
    // print(result);
    setState(() {
      if (result.isEmpty) {
        _hasData = false;
        return;
      }
      if (_myList.isEmpty) {
        _initialPk = result[0]["pk"];
      }
      _myList.addAll(result);
      _isLoading = false;
    });
  }

  _scrollListener() async {
    if (_isLoading | !_hasData) return;
    if (_controller.offset == _controller.position.maxScrollExtent) {
      _getChatList();
    }
  }

  Future _refresh() async {
    _initialPk = null;
    _myList = [];
    totalLength = 0;
    _isLoading = false;
    _hasData = true;

    _getChatList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where("pk", isGreaterThan: _initialPk)
            .orderBy("pk", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docs = snapshot.data!.docs;
            totalLength = docs.length + _myList.length;
            List result = [...docs, ..._myList];

            return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                controller: _controller,
                itemCount: result.length + 1,
                itemBuilder: (context, index) {
                  if (index < result.length) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatDetail(
                                  id: result[index]["pk"],
                                  title: result[index]["title"],
                                  timestamp: result[index]["created_at"],
                                )));
                      },
                      child: ChatList(result[index]["pk"],
                          result[index]["title"], result[index]["created_at"]),
                    );
                  }
                  return !_hasData && _isLoading
                      ? null
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: CircularProgressIndicator(),
                          ),
                        );
                });
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
