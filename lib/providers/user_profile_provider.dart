import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserProfileProvider extends ChangeNotifier {
  List _images = List.generate(6, (index) => null, growable: false);
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  final _storageRef = FirebaseStorage.instance.ref("");

  get thumbnail => _images.first;
  get images => _images;

  Future getImages() async {
    print("get Images from firebase storage");
    final result = await _storageRef.child("users/$_userId").listAll();

    await Future.wait(result.items.map(_downloadTask))
        .timeout(Duration(seconds: 5))
        .then((value) => print("$value"))
        .catchError((e) => print("$e"))
        .whenComplete(
          () => print("Loading images successed"),
        );

    notifyListeners();
    print("done");
    return thumbnail;
  }

  Future _downloadTask(item) async {
    int i = int.parse(item.name.split(".")[0]);
    print("$i");
    _images[i] = await item.getDownloadURL();
    print("$i done");
    return _images[i];
  }

  set setImages(resultList) {
    _images.setAll(0, resultList);
    print(_images);
  }

  // Create Provider
  // Future getImageList() async {
  //   return await _storageRef.child("users/$_userId").listAll();
  // }

  // UserProfileProvider() {
  //   this.getImageList().then((value) {
  //     print(value);
  //     this.setImages = value.items;
  //   });
  //   print("created new Provider");
  // }
}

class UserProvider extends ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future getUserInformation() async {
    return await storage.read(key: "KEY");
  }

  Future getData(token) async {
    return await http
        .post(Uri.parse("https://127.0.0.1/api/v1/chats/1"), headers: {
      "Authorization": token,
      "Content-Type": "Application/json",
    });
  }

  UserProvider() {
    this
        .getUserInformation()
        .then((token) => getData(token).timeout(Duration(seconds: 5)).then(
              (value) {
                print(value);
                return jsonDecode(value);
              },
            ).catchError((e) => print(e)))
        .catchError((e) => print(e));
  }
}
