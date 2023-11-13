import 'package:chats/components/page_match.dart';
import 'package:chats/components/page_past.dart';
import 'package:chats/components/widget_alarm.dart';
import 'package:chats/components/widget_shop.dart';
import 'package:chats/providers/daily_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/page_today.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> with SingleTickerProviderStateMixin {
  _showGetPoint() async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("리워드 지급"),
          content: Text("데일리 카드 획득을 포기하고\n1 포인트가 지급됩니다."),
          actions: [
            ElevatedButton(
                onPressed: () {
                  // TODO : set API
                  Navigator.of(context).pop();
                },
                child: Text("확인")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("취소")),
          ],
        );
      },
    );
  }

  List data = [];

  late TabController _controller;
  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<DailyProvider>();
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              Container(
                child: SliverAppBar(
                  shadowColor: Colors.white,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(" APP NAME"),
                  ),
                  pinned: true,
                  floating: true,
                  snap: true,
                  actions: [
                    Shop(),
                    Alarm(),
                  ],
                  bottom: TabBar(controller: _controller, tabs: [
                    Tab(
                      text: "오늘의 프로필",
                    ),
                    Tab(
                      text: "지나간 프로필",
                    ),
                    Tab(
                      text: "매칭된 프로필",
                    ),
                  ]),
                ),
              )
            ];
          },
          body: TabBarView(
            controller: _controller,
            children: [
              Today(),
              Past(),
              Match(),
            ],
          )),
    );
  }
}
