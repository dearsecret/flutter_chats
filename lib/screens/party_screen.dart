import 'package:chats/components/widget_alarm.dart';
import 'package:chats/components/widget_my.dart';
import 'package:chats/components/widget_search.dart';
import 'package:chats/components/widget_shop.dart';
import 'package:chats/providers/party_provider.dart';
import 'package:chats/screens/party_detail.dart';
import 'package:chats/screens/party_write.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Party extends StatefulWidget {
  const Party({super.key});

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> with SingleTickerProviderStateMixin {
  List<dynamic> data = [];

  late TabController _tabcontroller;

  @override
  void dispose() {
    _tabcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabcontroller = TabController(length: 3, vsync: this);
    super.initState();
  }

  Future _scrollListener() async {}
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PartyProvider>();
    final data = provider.data;
    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PartyWrite()));
          },
          icon: Icon(Icons.border_color)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text("소모임"),
            ),
            // expandedHeight: 150.0,
            // flexibleSpace: const FlexibleSpaceBar(
            //   title: Text('Available seats'),
            // ),
            actions: [
              Search(),
              Shop(),
              My(),
              Alarm(),
            ],
            floating: true,
            snap: true,
            bottom: TabBar(
              controller: _tabcontroller,
              tabs: [
                Tab(
                  text: "전체",
                ),
                Tab(
                  text: "만남",
                ),
                Tab(
                  text: "셀소",
                ),
              ],
            ),
          ),
          NotificationListener(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent) {
                _scrollListener();
              }
              return false;
            },
            child: SliverPadding(
              padding: EdgeInsets.all(10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final image = ExtendedImage.network(
                    data[index]["photo"],
                  );
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return PartyDetail(
                              index: index,
                              pk: data[index]["pk"],
                              image: image,
                              gender: data[index]["user"]["gender"],
                              title: data[index]["title"],
                              date: data[index]["created"]);
                        },
                      ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: index,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: image.image, fit: BoxFit.cover),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      spreadRadius: 1)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.circle,
                                color: data[index]["user"]["gender"]
                                    ? Colors.blueAccent[100]
                                    : Colors.red[200],
                                size: 11,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  "${data[index]["title"]}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }, childCount: data.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1 / 1.618,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
