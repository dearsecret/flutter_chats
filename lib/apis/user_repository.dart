import 'dart:convert';
import 'package:chats/models/public_user.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

class UserRepository {
  Future<String?> _authRequest(
      {required String method, required String url, Map? body}) async {
    // Map<String, dynamic>? body}) async {
    var token = await storage.read(key: "token");
    http.Request request =
        http.Request(method, Uri.parse("http://127.0.0.1:8000/api/v1" + url));
    request.headers.clear();
    if (token != null) {
      print("AUTH");
      request.headers
          .addAll({"Authorization": token, "Content-Type": "Application/json"});
      // request.body = jsonEncode(body);
      request.body = jsonEncode(body);

      // backends response exception 추가
      http.StreamedResponse response = await request.send();
      // if (response.statusCode != 200) {
      //   return null;
      // }
      var responseData = await response.stream.toBytes();
      var responseString = utf8.decode(responseData);
      // response.statusCode 추가
      // print("${body}");
      return responseString;
    } else {
      print("token 없음");
      // logout 함수 추가
    }
    return null;
  }

  Future<PublicUser> _fetchUser() async {
    String? result = await _authRequest(method: "POST", url: '/users/profile');
    print("user 기본정보");
    return PublicUser.fromJson(jsonDecode(result!));
  }

  Future<UserInfo> _fetchUserInfo() async {
    String? result = await _authRequest(method: "POST", url: '/users/photos');
    print("user 개인정보");
    return UserInfo.fromJson(jsonDecode(result!));
  }

  Future chat(Map<String, dynamic> body) async {
    await _authRequest(method: "POST", url: '/chats/chat', body: body);
    print("message 송신");
    return null;
  }

  Future chatMore(int totalLength) async {
    var res = await _authRequest(method: "GET", url: '/chats/$totalLength');
    return jsonDecode(res!).cast<Map<String, dynamic>>();
  }

  Future comment(Map<String, dynamic> body) async {
    await _authRequest(method: "POST", url: '/chats/comment', body: body);
    print("message 송신");
    return null;
  }

  //  하나씩 업로드하는 방식
  // Future getUpload(Map memory) async {
  //   for (var k in memory.keys) {
  //     if (memory[k] is File) {
  //       String? result =
  //           await _authRequest(method: "POST", url: '/images/upload');
  //       print("user image 업로드");
  //       String uploadUrl = jsonDecode(result!)["uploadUrl"];
  //       _uploadImage(uploadUrl, memory[k]);
  //       // result = _uploadImage(uploadUrl, memory[k]);
  //       result = await _uploadImage(uploadUrl, memory[k]);
  //       memory[k] = result;
  //     }
  //   }
  //   print("$memory");
  //   // await _authRequest(method: "PUT", url: "/images/upload", body: memory);
  //   // Needs to setting backends request.data
  // }

  Future getUpload(Map<String, dynamic> memory) async {
    final s = DateTime.now();
    // copy
    Map<String, dynamic> data = Map.from(memory);
    int cnt = 0;
    for (var k in data.keys) {
      if (data[k] is File) {
        ++cnt;
      }
    }

    // * get Upload Link
    // 사진이 변화할 때 링크를 줄 수 있지만, 후자는 갯수만큼 한번에 링크를 받는다.
    Map<String, int> body = {"cnt": cnt};
    String? res =
        await _authRequest(method: "POST", url: '/images/upload', body: body);

    var urls = jsonDecode(res!)["uploadUrl"];
    // * File uploading..
    // cf) Future.forEach
    await Future.wait([
      ...data.keys.map((key) async {
        if (data[key] is File) {
          data[key] = await _uploadImage(urls.removeLast(), data[key]);
        }
      })
    ]);
    print("${DateTime.now().difference(s)}");
    print(data);
    await _authRequest(
        method: "PUT", url: "/images/upload", body: {"data": data});
    // Needs to setting backends request.data
    print("${DateTime.now().difference(s)}");
  }

  // * get Uploaded Link
  Future<String?> _uploadImage(
    String uploadUrl,
    File file,
  ) async {
    print("upload start");
    var request = http.MultipartRequest("POST", Uri.parse(uploadUrl));
    // request.fields["requireSignedURLs"] = "true";
    request.headers["requireSignedURLs"] = "true";
    var pic = await http.MultipartFile.fromPath("file", file.path);
    request.files.add(pic);
    var response = await request.send();
    if (!(response.statusCode).toString().startsWith("4")) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var result = jsonDecode(responseString)["result"];
      return result["variants"][0];
    }
    return null;
  }
}

class UserProvider with ChangeNotifier {
  UserRepository _repository = UserRepository();
  User _user = User();
  Map<String, dynamic> selectedImage = {};
  int selected = 0;
  String get name => _user.user!.name;
  String get id => _user.user!.pk;
  Map<String, dynamic> get initializeImage {
    clearImages();
    _user.info!.photos.asMap().forEach((key, value) {
      selectedImage["${key}"] = value;
    });
    return selectedImage;
  }

  Image? make_iamge(String index, AnimationController? controller) {
    if (selectedImage.containsKey(index)) {
      print("이미지 생성");
      var element = selectedImage[index];
      if (element.runtimeType == String) {
        return Image(
          image: ExtendedImage.network(
            element,
            cache: true,
            // loadStateChanged: (ExtendedImageState state) {
            //   switch (state.extendedImageLoadState) {
            //     case LoadState.loading:
            //       break;
            //     case LoadState.completed:
            //       controller!.forward();
            //       return FadeTransition(
            //         opacity: controller,
            //         child: ExtendedRawImage(
            //           image: state.extendedImageInfo?.image,
            //         ),
            //       );
            //     case LoadState.failed:
            //       break;
            //   }
            // },
          ).image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Text("Null"),
        );
      } else if (element is File) {
        print("파일 감지");
        return Image(
          image: FileImage(element),
          fit: BoxFit.cover,
        );
      } else {
        throw Exception("지원하지 않는 타입입니다.");
      }
    }
    return null;
  }

  removeElement(String index) {
    selectedImage.remove(index);
    notifyListeners();
  }

  clearImages() {
    selectedImage = {};
  }

  deleteInfo() async {
    _user = User();
  }

  fetchUser() async {
    PublicUser user = await _repository._fetchUser();
    _user.addUser = user;
    print("유저 기본정보 프로바이더 작동");
    notifyListeners();
  }

  fetchUserInfo() async {
    UserInfo info = await _repository._fetchUserInfo();
    _user.addInfo = info;
    print("유저 개인정보 프로바이더 작동");

    // 오류 구문!!!!!!!!@#@!#@!#@!
    // _cachedImage.clear();
    // info.photos.asMap().forEach((key, value) async {
    //   // DefalutCacheManage async
    //   // https://pub.dev/documentation/flutter_cache_manager/latest/flutter_cache_manager/DefaultCacheManager-class.html
    //   // Key값은 중복저장되지 않는다. 가능하면 getSingleFile 사용 (기간설정이 가능)

    //   // (1)
    //   // .getSingleFile(value, key:key).then(value.path=> stored to "libCachedImageData/")
    //   await DefaultCacheManager()
    //       .getSingleFile(value, key: "$key")
    //       .then((file) {
    //     _cachedImage.insert(key, file);
    //   });
    //   //     .then((file) {
    //   //   _cachedImage[key] = value;
    //   // }
    //   // );
    //   print("$key 이미지 캐싱 완료");

    //   // .then((file) => print(file));
    //   // FileInfo? fileCached =
    //   //     await DefaultCacheManager().getFileFromCache("$key");
    //   // print("파일경로: ${fileCached!.file.path}");

    //   // (2)
    //   // .downloadFile(value, key:key).then(value.file => stored to "LOCAL .../libCachImage/" )

    //   // DefaultCacheManager()
    //   //     .downloadFile(value, key: "$key")
    //   //     .then((fileInfo) => print(fileInfo.file));
    //   // FileInfo? something =
    //   //     await DefaultCacheManager().getFileFromCache("$key");
    //   // print("파일경로: ${something!.file}");

    //   // (3)
    //   // Stream<FileResponse> something = DefaultCacheManager()
    //   //     .getImageFile(value, key: "$key");
    // });

    notifyListeners();
  }
}
