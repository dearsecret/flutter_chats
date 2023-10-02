import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  ChatList(this.pk, this.title, this.created_at, {super.key});
  final int pk;
  final String title;
  final dynamic created_at;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("$pk"),
      title: Text("$title"),
      subtitle: Text("$created_at"),
    );
  }
}
