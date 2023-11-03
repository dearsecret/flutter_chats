import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

FlutterSecureStorage storage = FlutterSecureStorage();

// TODO: create SERVER REST API
showAlert(BuildContext context, int pk) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("신고하기"),
        content: TextFormField(
          maxLines: null,
          decoration: InputDecoration(
              hintText: "신고사유", hintStyle: TextStyle(color: Colors.grey)),
        ),
        actions: [
          Container(
            child: ElevatedButton(
              onPressed: () {},
              child: Text("신고하기"),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
          )
        ],
      );
    },
  );
}

sendMessage(int pk, String content) async {
  final token = await storage.read(key: "token");
  final url = "";
  Map data = {"pk": pk, "content": content};
  http.Response response = await http.post(Uri.parse(url),
      headers: {"Authorization": token!, "Content-Type": "Application/json"},
      body: jsonEncode(data));
}

void _showModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          child: Text("hello"),
          heightFactor: 0.9,
        );
      },
      useSafeArea: true,
      isScrollControlled: true);
}

showConfirm(BuildContext context, int pk) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(content: Text("삭제하시겠습니까?"), actions: [
          Container(
            child: ElevatedButton(
              onPressed: () {},
              child: Text("삭제하기"),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
          )
        ]);
      });
}
