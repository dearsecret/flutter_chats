import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/alert.dart';

class DailyProvider extends ChangeNotifier {
  Map _data = {};
  Map _history = {};
  DateTime? _lastUpdated;

  get getData => (int index) {
        return _data[index];
      };
  set setCard(int index) {
    _getDailyCard(index);
  }

  get getHistory => _history;
  get setHistory => {if (_history.isEmpty) _getHistory()};

  DailyProvider() {
    _getDailyList();
    Timer.periodic(Duration(seconds: 1), (_) {
      _checkDate();
    });
  }

  _checkDate() {
    if (_lastUpdated != null) {
      if (DateTime.now().day != _lastUpdated!.subtract(Duration(hours: 12)).day)
        _data = {};
    }
  }

  _getDailyList() async {
    print("fetch");
    final token = await storage.read(key: "token");
    http.Response response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/v1/services/daily"),
        headers: {
          "Authorization": token!,
          "Content-Type": "Applcation/json",
        });
    if (response.statusCode == 200) {
      _data = Map.of(jsonDecode(utf8.decode(response.bodyBytes)).asMap());
      notifyListeners();
    }
  }

  _getDailyCard(int index) async {
    if (_data[index] != null) return print("stopped");
    final token = await storage.read(key: "token");
    http.Response response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/v1/services/daily"),
        headers: {
          "Authorization": token!,
          "Content-Type": "Applcation/json",
        });
    if (response.statusCode == 200) {
      if (utf8.decode(response.bodyBytes).isNotEmpty) {
        _data[index] = jsonDecode(utf8.decode(response.bodyBytes));
        // _lastData = _data[index]["created"];
        print(_data[index]);
        _lastUpdated = DateTime.parse(_data[index]["created"]).toLocal();
        print(_lastUpdated);
      }
      notifyListeners();
    }
  }

  _getHistory() async {
    final token = await storage.read(key: "token");
    http.Response response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/v1/services/history"),
        headers: {
          "Authorization": token!,
          "Content-Type": "Applcation/json",
        });
    if (response.statusCode == 200) {
      _history = Map.of(jsonDecode(utf8.decode(response.bodyBytes)).asMap());
      notifyListeners();
    }
  }
}
