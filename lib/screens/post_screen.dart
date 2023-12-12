import 'package:chats/components/post_realtime.dart';
import 'package:chats/components/widget_search.dart';
import 'package:chats/components/widget_shop.dart';
import 'package:chats/screens/posts_write_screen.dart';
import 'package:flutter/material.dart';

import '../components/widget_alarm.dart';
import '../components/widget_my.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> with TickerProviderStateMixin {
  late TabController _tabController;
  bool isFetched = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PostWrite()));
          },
          icon: Icon(Icons.border_color)),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  " 만남의 광장",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              actions: [
                Search(),
                Shop(),
                My(),
                Alarm(),
              ],
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(controller: _tabController, tabs: [
                Tab(
                  text: "Real Time",
                ),
                Tab(
                  text: "Best",
                ),
                Tab(
                  text: "내가 쓴글",
                )
              ]),
            )
          ];
        },
        body: TabBarView(controller: _tabController, children: [
          Realtime(),
          Text("new Page"),
          Text("my Page"),
        ]),
      ),
    );
  }
}
