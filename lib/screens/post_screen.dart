import 'package:chats/components/post_realtime.dart';
import 'package:flutter/material.dart';

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
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text("Lounge"),
            ),
            actions: [
              Icon(Icons.search),
              Icon(Icons.shopping_bag_outlined),
              Icon(Icons.notifications_active_outlined),
            ],
            toolbarHeight: 50,
            pinned: true,
            floating: true,
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
    );
  }
}
