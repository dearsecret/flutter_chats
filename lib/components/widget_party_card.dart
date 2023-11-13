import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PartyCard extends StatelessWidget {
  late final String title;
  late final bool gender;
  late final int index;
  late final ExtendedImage image;
  PartyCard(
      {super.key,
      required Map data,
      required int this.index,
      required ExtendedImage this.image})
      : title = data["title"],
        gender = data["user"]["gender"];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Hero(
            tag: index,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(image: image.image, fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 3, spreadRadius: 1)
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.circle,
                color: gender ? Colors.blueAccent[100] : Colors.red[200],
                size: 11,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  "$title",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
