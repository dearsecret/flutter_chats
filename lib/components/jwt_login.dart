import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JWTLogin extends StatefulWidget {
  const JWTLogin(this.addKey,
      {super.key, required this.username, required this.password});
  final Function addKey;
  final String username;
  final String password;
  @override
  State<JWTLogin> createState() => _JWTLoginState();
}

class _JWTLoginState extends State<JWTLogin> {
  void _loginJWT() async {
    final username = widget.username;
    final password = widget.password;
    final addKey = widget.addKey;
    Map data = {
      "username": username,
      "password": password,
    };
    var body = jsonEncode(data);
    String url = "http:127.0.0.1:8000/users/jwt-login";
    var res = await http.post(Uri.parse(url),
        body: body, headers: {"content-type": "application/json"});
    if (res.statusCode == 200) {
      await addKey(jsonDecode(res.body)["token"]);
    } else {
      print("failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          _loginJWT;
        },
        icon: const Icon(Icons.login));
  }
}
