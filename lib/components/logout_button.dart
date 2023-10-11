import 'package:chats/screens/logout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

class SignOut extends StatelessWidget {
  const SignOut({super.key});
  void logout() async {
    await FirebaseAuth.instance.signOut();
    await storage.delete(key: "token");
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          logout;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LogOut()));
        },
        icon: Icon(Icons.logout_outlined));
  }
}
