import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PartyProvider extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://dating-chats-dearsecret-default-rtdb.asia-southeast1.firebasedatabase.app/")
    ..setPersistenceEnabled(true)
    ..setPersistenceCacheSizeBytes(10000000);
  var childChangedListener;
  List<dynamic> _data = [];
  String? _token;

  static final storage = FlutterSecureStorage();

  get data => _data;

  set _setToken(value) {
    this._token = value;
  }

  Future<String?> readToken() async {
    await storage.read(key: "token").then((value) => print(value));
    return await storage.read(key: "token");
  }

  getData() async {
    http.Response response = await http
        .get(Uri.parse("http://127.0.0.1:8000/api/v1/meetings/list"), headers: {
      "Authorization": _token!,
      "Content-Type": "Applciation/json"
    });
    if (response.statusCode == 200) {
      _data = jsonDecode(utf8.decode(response.bodyBytes));
      print(_data);
    }
  }

  _onChildChanged(DatabaseEvent event) {
    final value = event.snapshot.value as Map;
    switch (event.snapshot.key) {
      case "add":
        _data.insert(0, value);
        break;
      case "remove":
        _data.removeWhere((element) => element["pk"] == value["pk"]);
        break;
    }

    notifyListeners();
  }

  PartyProvider() {
    this.readToken().then((token) {
      if (token != null) {
        this._setToken = token;

        getData().whenComplete(() {
          notifyListeners();
          childChangedListener =
              database.ref("meetings").onChildChanged.listen(_onChildChanged);
        });
      } else {
        // logout
      }
    });
  }
}
