import 'package:chats/screens/search_screen.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      child: Container(
        margin: EdgeInsets.all(3),
        child: Icon(Icons.search),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SearchScreen(),
        ));
      },
    );
  }
}
