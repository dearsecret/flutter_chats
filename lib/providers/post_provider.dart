import 'package:chats/models/post_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../utils/request.dart';

class PostProvider extends ChangeNotifier {
  // TODO : Listener should controll REMOVE and ADD
  FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://dating-chats-dearsecret-default-rtdb.asia-southeast1.firebasedatabase.app/")
    ..setPersistenceEnabled(true)
    ..setPersistenceCacheSizeBytes(10000000);
  var childChangedListener;

  List<dynamic> _postList = [];
  get data => _postList;

  Future getMore() async {
    await DefaultRequest.get(path: "/chats/${_postList.length}").then((resp) {
      return _postList.addAll(resp);
    });
    notifyListeners();
  }

  _onChildChanged(DatabaseEvent event) {
    print("Stream WORKING");
    switch (event.snapshot.key) {
      case "add":
        _postList = [event.snapshot.value, ..._postList];
      case "comment":
        Map data = event.snapshot.value as Map;
        _addComment(comment: _comment, value: data);
      case "remove":
        Map data = event.snapshot.value as Map;
        _removeComment(comment: _comment, value: data);
      case "hits":
        Map data = event.snapshot.value as Map;
        _countHits(repository: _postList, data: data);
    }
    notifyListeners();
  }

  PostProvider() {
    print("provider created!!");
    DefaultRequest.get(path: "/chats/0").then((resp) {
      _postList = [...resp];
      notifyListeners();
    }).whenComplete(() {
      childChangedListener =
          database.ref("posts").onChildChanged.listen(_onChildChanged);
    });
  }

  // SET DETAIL PAGE
  PostModel? _detail;
  List<dynamic>? _comment;
  List<dynamic>? _exchange;
  get getDetail => _detail;
  get getComment => _comment;
  List? get getExchange => _exchange;
  Future getDetialPage(int pk) async {
    if (_detail?.pk == pk) return _detail;
    // await Future.delayed(Duration(seconds: 1));
    print("get Data");
    await DefaultRequest.get(path: "/chats/chat/$pk").then((value) {
      _comment = value.remove("comments");
      _exchange = value.remove("exchange");
      // SORT
      _comment?.sort((a, b) =>
          (a["parent"] ?? a["pk"]).compareTo((b["parent"] ?? b["pk"])));

      _detail = PostModel.fromData(value);
    });
    return _detail;
  }

  Future writeComment(
      {required int pk, required String content, int? selected_comment}) async {
    print("send comment");
    Map<String, dynamic> data = {
      "content": content,
    };
    if (selected_comment != null) {
      data["parent"] = selected_comment;
    }
    await DefaultRequest.post(path: "/chats/chat/$pk/comment", data: data)
        .then((value) {
      _addComment(comment: _comment, value: value, isResponse: true);
    });
    notifyListeners();
  }
}

// ===========================My Function for RESTFUL API===========================
// Response ADD COMMENT FUNCTION
void _addComment(
    {required List? comment, required Map value, bool isResponse = false}) {
  if (!isResponse) {
    // Response 가 먼저온 경우 : ignore && finish
    print("Stream data");
    if (comment?.any((element) => element["pk"] == value["pk"]) ?? false) {
      print("stop");
      return;
    }
  } else {
    // Stream 이 먼저온 경우 : overriding && finish
    print("Response data");
    if (comment?.any((element) => element["pk"] == value["pk"]) ?? false) {
      comment?.lastWhere((element) => element["pk"] == value["pk"])["author"]
          ["is_owner"] = true;
      print("stop");
      return;
    }
  }

  // new Value add data
  int? parent = value['parent'];
  if (parent != null) {
    print("reply data");
    // var e = comment!.lastWhere(
    //     (element) => element["parent"] == parent || element["pk"] == parent,
    //     orElse: () {
    //   comment.add(value);
    //   return null;
    // });
    // if (e == null) return;
    // e = [e].expand((element) => [element, value]);

    try {
      int newIndex = comment!.lastIndexWhere((element) =>
              element["parent"] == parent || element["pk"] == parent) +
          1;
      comment.insert(newIndex, value);
    } catch (e) {
      print("add Comment throw Error");
    }
  } else {
    print("new data");
    comment!.add(value);
  }
}

void _countHits({required List repository, required Map data}) {
  print("count hits");
  repository.lastWhere((element) => element["pk"] == data["pk"],
      orElse: () => null)?["views"] = data["views"];
}

void _removeComment(
    {required List? comment, required Map value, bool isResponse = false}) {
  if (!isResponse) {
    print("try stream remove");
    try {
      comment?.lastWhere((element) => element["pk"] == value["pk"], orElse: () {
        throw "There's No pk";
      })["content"] = null;
    } catch (e) {
      print("REMOVE COMMENT THROW : $e");
    }
  }
}
