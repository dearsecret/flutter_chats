import 'dart:async';

import 'package:flutter/material.dart';

class Init extends ChangeNotifier {
  // About Firestore for Notification
  List _repository = [];
  bool _isInit = true;
  late Timer timer;
  get isInit => _isInit;

  get getRepository => _repository;
  set setRepository(List value) {
    if (this._isInit) {
      if (value.isNotEmpty)
        value.sort((a, b) => b["timestamp"].compareTo(a["timestamp"]));
      this._repository = value;
      this._isInit = false;
    }
  }

  set addRepository(Map value) {
    if (!this._isInit) this._repository.insert(0, value);
    notifyListeners();
  }

  _removeRepository(_) {
    if (_repository.isNotEmpty) {
      if (this._repository.last["timestamp"] * 24 * 7 * 60 * 60 <
          DateTime.now().millisecondsSinceEpoch)
        _repository.remove(this._repository.last);
    }
  }

  Init() {
    this.timer = Timer.periodic(Duration(seconds: 1), _removeRepository);
  }
}
