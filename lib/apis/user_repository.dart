import 'dart:convert';
import 'package:chats/models/public_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _url = "http://127.0.0.1:8000/api/v1";
final FlutterSecureStorage storage = FlutterSecureStorage();

class UserRepository {
  Future<PublicUser> fetchUser() async {
    final token = await storage.read(key: "token");
    final resp = await http.post(Uri.parse('$_url' + '/users/profile'),
        headers: {"Authorization": "$token"});
    if (resp.statusCode == 200) {
      print("유저 기본정보 패치");
      return PublicUser.fromJson(jsonDecode(utf8.decode(resp.bodyBytes)));
    }
    throw Exception("");
  }

  Future<UserInfo> _fetchUserInfo() async {
    final token = await storage.read(key: "token");
    final resp = await http.post(Uri.parse('$_url' + '/users/photos'),
        headers: {"Authorization": "$token"});
    if (resp.statusCode == 200) {
      print("유저 사진 & 이메일 패치");
      return UserInfo.fromJson(jsonDecode(utf8.decode(resp.bodyBytes)));
    }
    throw Exception("");
  }
}

class UserProvider with ChangeNotifier {
  UserRepository _repository = UserRepository();
  PublicUser _user = PublicUser(pk: "", name: "", points: 0);
  String get name => _user.name;

  UserInfo _info = UserInfo(username: "", photos: []);
  List<dynamic> get photos => _info.photos;

  List<dynamic> _cachedImage = [];
  List<dynamic> get cachedImage => _cachedImage;

  deleteInfo() async {
    _user = PublicUser(pk: "", name: "", points: 0);
    _info = UserInfo(username: "", photos: []);
  }

  fetchUser() async {
    PublicUser user = await _repository.fetchUser();
    _user = user;
    print("유저 기본정보 프로바이더 작동");
    print("$_user");
    notifyListeners();
  }

  fetchUserInfo() async {
    UserInfo info = await _repository._fetchUserInfo();
    print("유저 개인정보 프로바이더 작동");
    _cachedImage.clear();
    info.photos.asMap().forEach((key, value) {
      // DefalutCacheManage async
      // https://pub.dev/documentation/flutter_cache_manager/latest/flutter_cache_manager/DefaultCacheManager-class.html
      // Key값은 중복저장되지 않는다. 가능하면 getSingleFile 사용 (기간설정이 가능)

      // (1)
      // .getSingleFile(value, key:key).then(value.path=> stored to "libCachedImageData/")
      DefaultCacheManager()
          .getSingleFile(value, key: "$key")
          .then((file) => _cachedImage.add(file));
      print("$key 이미지 캐싱 중");
      // .then((file) => print(file));
      // FileInfo? fileCached =
      //     await DefaultCacheManager().getFileFromCache("$key");
      // print("파일경로: ${fileCached!.file.path}");

      // (2)
      // .downloadFile(value, key:key).then(value.file => stored to "LOCAL .../libCachImage/" )

      // DefaultCacheManager()
      //     .downloadFile(value, key: "$key")
      //     .then((fileInfo) => print(fileInfo.file));
      // FileInfo? something =
      //     await DefaultCacheManager().getFileFromCache("$key");
      // print("파일경로: ${something!.file}");

      // (3)
      // Stream<FileResponse> something = DefaultCacheManager()
      //     .getImageFile(value, key: "$key");
    });

    notifyListeners();
  }
}
