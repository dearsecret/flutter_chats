import 'package:chats/screens/service_detail_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

import '../providers/daily_provider.dart';

class ChoiceHistory extends StatefulWidget {
  late final int index;
  ChoiceHistory({super.key, required int this.index});

  @override
  State<ChoiceHistory> createState() => _ChoiceHistoryState();
}

class _ChoiceHistoryState extends State<ChoiceHistory> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyProvider>().getHistory(widget.index);
    return GestureDetector(
      onTap: () {
        // TODO : 제스처 ServiceDetail 할당
        // Navigator.of(context).push(PageRouteBuilder(
        //   pageBuilder: (context, animation, secondaryAnimation) {
        //     return ServiceDetail(index: widget.index);
        //   },
        //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //     return FadeTransition(
        //       opacity: animation,
        //       child: child,
        //     );
        //   },
        // ));
      },
      child: Column(
        children: [
          Expanded(
            child: Hero(
              tag: widget.index,
              child: Container(
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ExtendedImage.network(
                          provider.selected.thumbnail,
                          cache: true,
                        ).image,
                        fit: BoxFit.cover),
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 5)],
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          TimerBuilder.periodic(
            Duration(seconds: 1),
            builder: (context) {
              return Row(
                children: [
                  Expanded(
                      child: Text(
                    "D ${DateTime.now().difference(provider.created.add(Duration(days: 7))).inDays}",
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                  ))
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
