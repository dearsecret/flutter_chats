import 'package:chats/screens/my_screen.dart';
import 'package:flutter/material.dart';

class My extends StatelessWidget {
  const My({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      child: Container(
        margin: EdgeInsets.all(3),
        child: Stack(alignment: Alignment(0, -0.2), children: [
          Icon(
            Icons.person_outline,
            size: 19,
          ),
          Align(alignment: Alignment(0, 0.5), child: Text("me")),
        ]),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyScreen(),
        ));
      },
    );
  }
}
