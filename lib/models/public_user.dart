import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _url = "http://127.0.0.1:8000/api/v1";
final FlutterSecureStorage storage = FlutterSecureStorage();

class PublicUser {
  final String pk;
  final String name;
  final int points;

  PublicUser({required this.pk, required this.name, required this.points});

  factory PublicUser.fromJson(Map<String, dynamic> json) =>
      PublicUser(pk: json["pk"], name: json["name"], points: json["point"]);
}

class UserInfo {
  String username;
  List<dynamic> photos;

  UserInfo({
    required this.username,
    required this.photos,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : username = json["username"],
        photos = List<String>.from(json["photos"]);
}

// class Request with ChangeNotifier {
//   PublicUser _user = PublicUser(pk: "", name: "");
//   DetailUser _detail = DetailUser(username: "", photos: []);
//   String get name => _user.name;
//   List<String> get photos => _detail.photos;

//   PublicUser getUser() {
//     if (_user.pk.isEmpty) {
//       _fetchUser();
//     }
//     return _user;
//   }

//   DetailUser getUserDetail() {
//     if (_detail.username.isEmpty) {
//       _fetchDetail();
//     }
//     return _detail;
//   }

//   void _fetchUser() async {
//     final token = await storage.read(key: "token");
//     final resp = await http.post(Uri.parse('$_url' + '/users/profile'),
//         headers: {"Authorization": "$token"});
//     if (resp.statusCode == 200) {
//       _user = PublicUser.fromJson(jsonDecode(resp.body));

//       notifyListeners();
//     }
//   }

//   void _fetchDetail() async {
//     final token = await storage.read(key: "token");
//     final resp = await http.post(Uri.parse('$_url' + '/users/detail'),
//         headers: {"Authorization": "$token"});
//     if (resp.statusCode == 200) {
//       print(resp.body);
//       _detail = DetailUser.fromJson(jsonDecode(resp.body));
//       notifyListeners();
//       return;
//     }
//   }
// }
