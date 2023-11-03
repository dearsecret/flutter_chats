import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class PostProvider extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://dating-chats-dearsecret-default-rtdb.asia-southeast1.firebasedatabase.app/")
    ..setPersistenceEnabled(true)
    ..setPersistenceCacheSizeBytes(10000000);
  var childChangedListener;

  static final storage = FlutterSecureStorage();
  String? _token;
  List<dynamic> _postList = [];

  get data => _postList;
  set _setToken(value) {
    this._token = value;
  }

  Future<String?> readToken() async {
    await storage.read(key: "token").then((value) => print(value));
    return await storage.read(key: "token");
  }

  Future getData(token) async {
    return await http
        .get(Uri.parse("http://127.0.0.1:8000/api/v1/chats/0"), headers: {
      "Authorization": token,
      "Content-Type": "Application/json",
    });
  }

  Future getMore() async {
    await http.get(
        Uri.parse("http://127.0.0.1:8000/api/v1/chats/${_postList.length}"),
        headers: {
          "Authorization": _token!,
          "Content-Type": "Application/json",
        }).then((resp) {
      print(resp.body);
      return _postList.addAll(jsonDecode(utf8.decode(resp.bodyBytes)));
    });
    notifyListeners();
  }

  _onChildChanged(DatabaseEvent event) {
    // posts/add/data 변경시
    print(event.snapshot.key);
    print(event.snapshot.value);
    print(event.snapshot.value.runtimeType);
    final value = event.snapshot.value as Map;
    print(value.runtimeType);
    print(value["pk"]);
    switch (event.snapshot.key) {
      case "add":
        _postList.insert(0, event.snapshot.value);
        break;
    }

    notifyListeners();
  }

  PostProvider() {
    this.readToken().then((token) {
      print("set the token value");
      print(token);
      if (token != null) {
        this._setToken = token;
        print("token saved");
        getData(token)
            .then((resp) =>
                _postList.addAll(jsonDecode(utf8.decode(resp.bodyBytes))))
            .whenComplete(() {
          notifyListeners();
          print("works");
          childChangedListener =
              database.ref("posts").onChildChanged.listen(_onChildChanged);
          print("data fetched");
          print(_postList);
        });
      } else {
        // logout
      }
    });
  }

  // TODO : define by the snapshot.value
  _onValueListener(keyValue) {
    switch (keyValue) {
      case "add":
        break;
      case "change":
        break;
      case 'delete':
        break;
      default:
        print("no value");
    }
  }
}
