import 'package:chats/screens/logout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignOut extends StatelessWidget {
  static final FlutterSecureStorage storage = FlutterSecureStorage();
  const SignOut({super.key});
  void logout() async {
    await storage.deleteAll();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          logout();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LogOut()));
        },
        icon: Icon(Icons.logout_outlined));
  }
}
