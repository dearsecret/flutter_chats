import 'dart:async';
import 'package:chats/screens/post_detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Party extends StatefulWidget {
  const Party({super.key});
  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> {
  late ScrollController _controller;
  late DatabaseReference ref;
  var childAddedListener;
  var childChangedListener;

  // @override
  void initState() {
    _controller = new ScrollController()..addListener(_scorollListener);

    FirebaseDatabase database;
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    ref = database.ref('posts');

    //.orderByChild("timestamp").startAt(1696836938330)
    fetchDatabase();
    childAddedListener =
        ref.limitToLast(1).onChildAdded.listen(_onEntryAddedPost);
    childChangedListener =
        ref.limitToLast(20).onChildChanged.listen(_onEntryChangedPost);
    super.initState();
  }

  _scorollListener() {
    if (isLoading | !isMore) return;
    if (_controller.offset == _controller.position.maxScrollExtent) {
      isLoading = true;
      getMore();
    }
  }

  orderByTimestamp(Object? value) {
    return Map.from(value as Map).entries.toList()
      ..sort((a, b) => b.value['timestamp'].compareTo(a.value['timestamp']));
  }

  fetchDatabase() async {
    await ref.limitToLast(20).get().then((snapshot) {
      if (snapshot.value != null) {
        setState(() {
          posts = orderByTimestamp(snapshot.value);
          // posts = Map.from(snapshot.value as Map).entries.toList()
          //   ..sort(
          //       (a, b) => b.value['timestamp'].compareTo(a.value['timestamp']));
        });
      }
    }).catchError((error) {
      print("THIS IS FETCHED ERROR : $error");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    childAddedListener.cancel();
    childChangedListener.cancel();
    posts.clear();
    super.dispose();
  }

  List posts = [];
  bool isFetched = false;
  _onEntryAddedPost(DatabaseEvent event) {
    if (mounted && event.snapshot.exists && isFetched) {
      var snapshot = event.snapshot;
      if (posts.isNotEmpty) {
        if (snapshot.key != posts.first.key) {
          setState(() {
            posts.insert(0, MapEntry(snapshot.key, snapshot.value));
          });
        }
      } else {
        setState(() {
          posts.insert(0, MapEntry(snapshot.key, snapshot.value));
        });
      }
    } else {
      print("successful connected && it will get the first data");
      isFetched = true;
    }
  }

  _onEntryChangedPost(DatabaseEvent event) {
    print("changed");
    if (mounted && event.snapshot.exists) {
      var snapshot = event.snapshot;
      var old = posts.firstWhere((entry) {
        return entry.key == snapshot.key;
      });
      if (old != null) {
        setState(() {
          posts[posts.indexOf(old)] = MapEntry(snapshot.key, snapshot.value);
        });
      }
    }
  }

  // TODO : IMPLEMENT refresh Function
  Future _refresh() async {
    posts.clear();
    setState(() {
      posts;
    });
    _delete();
    // _getDataList();
  }

  _delete() async {
    final ref = FirebaseDatabase.instance.ref("posts/");
    print("delete");
    await ref.remove();
  }

  String selectedKey = "";
// selectedKey
  incrementCounter() async {
    await FirebaseDatabase.instance
        .ref("posts/$selectedKey/views")
        .set(ServerValue.increment(1));
    print("increment views");
  }

  // var ref = FirebaseDatabase.instance.ref('posts');
  // Stream<DatabaseEvent> _getCountViews() async* {
  //   await for (var event in ref.limitToLast(1).onChildAdded) {
  //     print("last one added");
  //     // stream 데이터의 흐름에 따라 Listener를 종료할 수 있도록 한다.
  //     yield event;
  //   }
  // }

  bool isMore = true;
  bool isLoading = false;
  getMore() {
    print(posts.last);
    ref
        .orderByChild("timestamp")
        .endBefore(posts.last.value["timestamp"])
        .limitToLast(5)
        .get()
        .then((snapshot) {
      if (snapshot.value != null) {
        setState(() {
          posts.addAll(orderByTimestamp(snapshot.value));
        });
      } else {
        setState(() {
          isMore = false;
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refresh,
        child: posts.isEmpty
            ? Text("No data")
            : ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                controller: _controller,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedKey = posts[index].key;
                        });
                        // incrementCounter();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetail(
                                    docId: selectedKey,
                                    docTitle: posts[index].value["title"],
                                  )),
                        );
                      },
                      child: ListTile(
                          title: Text("${posts[index].value["title"]}"),
                          subtitle: Row(
                            children: [
                              Text("${posts[index].value["views"] ?? 0}"),
                              Icon(Icons.pan_tool_alt_outlined),
                              Expanded(
                                child: Text(
                                  "${posts[index].value["uid"] ?? 'Anonymous'}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              )
                            ],
                          ),
                          trailing: Text("${posts[index].value["timestamp"]}")),
                    );
                  } else {
                    return isMore
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center(
                            child: Text("데이터가 존재하지 않습니다."),
                          );
                  }
                },
              ));
  }
}
