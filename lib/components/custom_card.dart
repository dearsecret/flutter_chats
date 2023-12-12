import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  late final Map data;
  CustomCard({super.key, required Map this.data});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  double _angle = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        setState(() {
          if (widget.data.isNotEmpty) {
            _angle = pi;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: _angle),
      duration: Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        // decide when show front and back
        bool _isBack = (value < pi / 2);
        return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value),
            alignment: Alignment.center,
            child: _isBack
                ? Container(
                    child: Center(
                        child: Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.brown[400],
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [BoxShadow(blurRadius: 5)],
                        borderRadius: BorderRadius.circular(20)),
                  )
                : GestureDetector(
                    // TODO : move to detail page
                    onTap: () {},
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: ExtendedImage.network(
                                  widget.data["user"]["thumbnail"],
                                  cache: true,
                                ).image,
                                fit: BoxFit.cover),
                            color: Colors.white,
                            boxShadow: [BoxShadow(blurRadius: 5)],
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ));
      },
    );
  }
}
