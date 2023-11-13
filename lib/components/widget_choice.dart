import 'dart:async';
import 'dart:math';

import 'package:chats/providers/daily_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Choice extends StatefulWidget {
  late final int index;
  Choice({super.key, required this.index});

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  double _angle = 0;
  bool _pending = false;
  bool _isSnackbarActive = false;
  late Timer _timer;

  @override
  void initState() {
    _checkPending();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _checkPending();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _checkPending() {
    final now = DateTime.now();
    if ((now.subtract(Duration(hours: 12)).hour ~/ 12 > 0) |
        (now.hour >= 12 + (widget.index ~/ 2) * 3)) {
      setState(() {
        _pending = true;
      });
    }
  }

  _showSnackBar(int index) {
    if (_isSnackbarActive) return;
    _isSnackbarActive = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(
            SnackBar(content: Text("${3 * (index ~/ 2)}시에 오픈할 수 있습니다.")))
        .closed
        .then((SnackBarClosedReason reason) {
      _isSnackbarActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DailyProvider>();
    return GestureDetector(
      onTap: !_pending
          ? () {
              _showSnackBar(widget.index);
            }
          : () {
              if (provider.getData(widget.index) == null) {
                context.read<DailyProvider>().setCard = widget.index;
                setState(() {
                  _angle = (_angle + pi) % (2 * pi);
                });
              } else {
                print("move");
                // Navigator.of(context).push(PageRouteBuilder(
                //   pageBuilder: (context, animation, secondaryAnimation) {
                //     var data = provider.getData(widget.index);
                //     return ServiceDetail(
                //         pk: data["pk"],
                //         name: data["name"],
                //         image: data["photos"][0]["url"]);
                //   },
                //   transitionsBuilder:
                //       (context, animation, secondaryAnimation, child) {
                //     final tween = Tween(begin: Offset(0, 1), end: Offset.zero)
                //         .chain(CurveTween(curve: Curves.easeInOut));
                //     return SlideTransition(
                //       position: animation.drive(tween),
                //       child: child,
                //     );
                //   },
                // ));
              }
            },
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: _angle),
        duration: Duration(milliseconds: 700),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          bool _isBack = (value >= pi / 2) ||
                  context.watch<DailyProvider>().getData(widget.index) != null
              ? false
              : true;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value),
            alignment: Alignment.center,
            child: _isBack
                ? Container(
                    child: _pending
                        ? Center(
                            child: Text(
                            "Today's Profile",
                            style: TextStyle(
                              color: Colors.brown[400],
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                        : Center(
                            child: Text("Stand by Profile",
                                style: TextStyle(color: Colors.grey))),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [BoxShadow(blurRadius: 5)],
                        borderRadius: BorderRadius.circular(20)),
                  )
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: Container(
                      decoration: BoxDecoration(
                          image: context
                                      .read<DailyProvider>()
                                      .getData(widget.index) ==
                                  null
                              ? null
                              : DecorationImage(
                                  image: ExtendedImage.network(
                                    context
                                            .watch<DailyProvider>()
                                            .getData(widget.index)["selected"]
                                        ["thumbnail"],
                                    cache: true,
                                  ).image,
                                  fit: BoxFit.cover),
                          color: Colors.white,
                          boxShadow: [BoxShadow(blurRadius: 5)],
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
