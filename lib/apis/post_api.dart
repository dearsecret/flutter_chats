import 'package:http/http.dart' as http;

String _url = "http://127.0.0.1:8000/api/v1/";
// String token = FlutterSecureStorage().read(key: "token");

class PostApi {
  // late String token;

  Future getData(token) async {
    return await http.get(Uri.parse(_url + "chats/0"), headers: {
      "Authorization": token,
      "Content-Type": "Application/json",
    });
  }

  Future getMore(token, len) async {
    return await http.get(Uri.parse(_url + "chats/$len"), headers: {
      "Authorization": token,
      "Content-Type": "Application/json",
    });
  }

  Future writeComment() async {}
  Future writeReply() async {}
  Future delete() async {}
  // Future deletPost(token, pk) async {
  //   return await http.post(Uri.parse(url + "chats/delete"), headers: {
  //     "Authorization": token,
  //     "Content-Type": "Application/json",
  //   });
  // }

  // PostApi(String token) : this.token = token;
}
