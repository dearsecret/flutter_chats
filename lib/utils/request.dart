import 'dart:convert';
import 'dart:io';
import 'package:chats/utils/storage.dart';
import 'package:http/http.dart' as http;

class DefaultRequest {
  static makeUri({required String path}) {
    return Uri.parse("http://127.0.0.1:8000/api/v1" + path);
  }

  static jsonToMap({required http.Response response}) =>
      jsonDecode(utf8.decode(response.bodyBytes));

  static Future<Map<String, String>> get makeHeader async {
    // TODO : try / catch
    final token = await Storage.getToken;
    return {"Content-type": "Application/json", "Authorization": token};
  }

  static Future get({required String path, bool auth = true}) async {
    return await makeHeader
        .then((headers) => http.get(DefaultRequest.makeUri(path: path),
            headers: auth ? headers : null))
        .then((resp) => jsonToMap(response: resp));
  }

  static Future post(
      {required String path, Map? data, bool auth = true}) async {
    return await makeHeader
        .then((headers) => http.post(DefaultRequest.makeUri(path: path),
            headers: auth ? headers : null, body: jsonEncode(data)))
        .then((resp) => jsonToMap(response: resp));
  }

  static Future delete({required String path, bool auth = true}) async {
    return await makeHeader
        .then((headers) => http.delete(
              DefaultRequest.makeUri(path: path),
              headers: auth ? headers : null,
            ))
        .then((resp) => jsonToMap(response: resp));
  }

  static Future put({required String path, Map? data}) async {
    return await makeHeader
        .then((headers) => http.put(DefaultRequest.makeUri(path: path),
            headers: headers, body: jsonEncode(data)))
        .then((resp) => jsonToMap(response: resp));
  }

  static Future uploadImages(List li) async {
    List copiedLi = [...li];
    var files = copiedLi.where((element) => element is File);

    await DefaultRequest.post(
        path: "/images/upload/",
        data: {"cnt": files.length}).then((urls) async {
      var _urls = List.of(urls["uploadUrl"]);
      await Future.wait(copiedLi.map((e) async {
        if (e is File)
          return copiedLi[copiedLi.indexOf(e)] =
              await _uploadImageServer(_urls.removeLast(), e)
                  .then((value) => value["result"]["variants"][0]);

        return copiedLi[copiedLi.indexOf(e)] = e;
      }));
    });
    print("act");
    return await DefaultRequest.put(
        path: "/images/upload/", data: {"pending": copiedLi});
  }

  static Future<Map> _uploadImageServer(String url, File f) async {
    print("start");
    var request = http.MultipartRequest("POST", Uri.parse(url))
      // v1
      // ..fields["requireSignedURLs"] = "true"
      ..files.add(await http.MultipartFile.fromPath("file", f.path));
    var response = await request.send();
    print("done");
    return jsonDecode(utf8.decode(await response.stream.toBytes()));
  }
}
