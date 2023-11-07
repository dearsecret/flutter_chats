import 'package:flutter/material.dart';

class Alarm extends StatelessWidget {
  const Alarm({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      child: Container(
        margin: EdgeInsets.all(3),
        child: Icon(Icons.notifications_none_outlined),
      ),
      onTap: () {},
    );
  }
}
