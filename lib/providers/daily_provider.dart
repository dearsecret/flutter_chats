import 'dart:async';
import 'dart:convert';
import 'package:chats/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/alert.dart';

class DailyProvider extends ChangeNotifier {
  Map _data = {};
  List _history = [];
  DateTime? _lastUpdated;

  get getData => (int index) {
        return _data[index];
      };
  set setCard(int index) {
    _getDailyCard(index);
  }

  get getHistoryLength => _history.length;

  get getHistory => (int index) {
        return _history[index];
      };
  get setHistory => {if (_history.isEmpty) _getHistory()};

  DailyProvider() {
    _getDailyList();
    Timer.periodic(Duration(seconds: 1), (_) {
      _checkDate();
    });
  }

  _checkDate() {
    if ((_lastUpdated?.subtract(Duration(hours: 12)).day !=
        DateTime.now().subtract(Duration(hours: 12)).day)) {
      if (_history.isNotEmpty & _data.isNotEmpty)
        _history.insertAll(
            0,
            _data.values.toList()
              ..sort((a, b) => b.created.compareTo(a.created)));
      _data = {};
    }
    if (_history.isNotEmpty)
      _history.removeWhere((element) =>
          DateTime.now().subtract(Duration(days: 7)).isAfter(element.created));
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
      _data = Map.of(jsonDecode(utf8.decode(response.bodyBytes))
          .map((e) => CardModel.fromJson(e))
          .toList()
          .asMap());
      _lastUpdated = DateTime.now();
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
        _data[index] =
            CardModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        _lastUpdated = DateTime.now();
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
      _history = List.of(jsonDecode(utf8.decode(response.bodyBytes))
          .map((e) => CardModel.fromJson(e))
          .toList());
      notifyListeners();
    }
  }

  // TODO : create Backends view
  _getDetail(DateTime date) async {
    final token = await storage.read(key: "token");
    http.Response response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/v1/services/history"),
        body: {
          "created": date
        },
        headers: {
          "Authorization": token!,
          "Content-Type": "Applcation/json",
        });
  }
}
