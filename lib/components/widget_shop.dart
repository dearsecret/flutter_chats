import 'package:flutter/material.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      child: Container(
        margin: EdgeInsets.all(3),
        child: Icon(Icons.shopping_cart_sharp),
      ),
      onTap: () {},
    );
  }
}
