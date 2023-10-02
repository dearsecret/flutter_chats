import 'dart:async';

import 'package:flutter/material.dart';

class Party extends StatefulWidget {
  const Party({super.key});

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> {
  String _datetime = DateTime.now().toString();
  late Timer _timer;

  void _update() {
    setState(() {
      _datetime = DateTime.now().toString();
    });
  }

  @override
  void initState() {
    _update();
    _timer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
    super.initState();
  }

  Future _refresh() async {}
  @override
  Widget build(BuildContext context) {
    return Text("${_datetime}");
    // return RefreshIndicator(
    //   onRefresh: _refresh,
    //   child: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         AspectRatio(aspectRatio: 4 / 1, child: Placeholder()),
    //         GridView.count(
    //           shrinkWrap: true,
    //           physics: NeverScrollableScrollPhysics(),
    //           crossAxisCount: 3,
    //           children: List.generate(
    //               15,
    //               (index) => Container(
    //                     child: Text("$index"),
    //                   )),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
