import 'package:flutter/material.dart';

class MiniProfile extends StatelessWidget {
  late bool gender;
  late String name, location;
  late String age;
  MiniProfile({super.key, required user})
      : this.gender = user["gender"],
        this.name = user["name"],
        this.location = user["location"],
        this.age = user["age"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: Icon(
            Icons.circle,
            color: gender ? Colors.blueAccent[100] : Colors.red[200],
            size: 11,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("$name"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("$age      "),
                Text("$location"),
              ],
            )
          ],
        )
      ],
    );
  }
}
