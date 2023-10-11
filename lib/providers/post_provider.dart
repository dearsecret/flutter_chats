import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  Map data = {};
  List keys = [];
  DatabaseReference _ref = FirebaseDatabase.instance.ref("posts");
  get setDB => _setDatabase();

  // stream<DatabaseEvent>
  // async* => Stream / async => Future
  // [...stream] = [FUTURE, FUTURE, ...]
  // yield vs yield* => iterate<T>
  Stream<DatabaseEvent> getEvent() async* {
    // _ref.onChildChanged.listen((event) async* {
    //   print(event);
    //   yield event;
    //   notifyListeners();
    // });

    // _ref.onValue.forEach((element) {element;});
    // await for (var event in _ref.onChildAdded) {
    //   print("${event.snapshot.key} added");
    //   yield event;
    // }

    await for (var event in _ref.limitToLast(1).onChildAdded) {
      // print(value.snapshot.value);
      print(event.snapshot.key);
      yield event;
      await for (var event in _ref.limitToLast(10).onChildChanged) {
        // print("${event.snapshot.value}");
        print("${event.snapshot.key}");
        yield event;
      }
    }
  }

  _setDatabase() async {
    data.clear();
    keys.clear();
    var snapshot = await _ref.get();
    if (snapshot.exists) {
      print("reset");
      data = snapshot.value as Map;
      keys = data.keys.toList();
      notifyListeners();
    } else {
      print("here's error ");
      return null;
    }
  }
}
