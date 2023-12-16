import 'package:chats/utils/time.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import '../providers/post_provider.dart';
import '../screens/post_detail_screen.dart';

class Realtime extends StatefulWidget {
  const Realtime({super.key});

  @override
  State<Realtime> createState() => _RealtimeState();
}

class _RealtimeState extends State<Realtime> {
  bool isMore = true;
  bool isLoading = false;

  _scrollListener() {
    if (isLoading) return;
    isLoading = true;
    context.read<PostProvider>().getMore();
    isLoading = false;
  }

  int? selectedKey;

  Future _refresh() async {}

  @override
  void initState() {
    TimeUtil.setLocalMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
          _scrollListener();
        }
        return false;
      },
      child: RefreshIndicator(
          onRefresh: _refresh,
          child: Selector<PostProvider, List>(
            selector: (p0, p1) => (p1.data),
            shouldRebuild: (previous, next) => true,
            builder: (context, data, child) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) => Divider(),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: data.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedKey = data[index]["pk"];
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostDetail(
                                  pk: data[index]["pk"],
                                  title: data[index]["title"]),
                            ),
                          );
                        });
                      },
                      child: ListTile(
                          leading: Text("${data[index]["pk"]}"),
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${data[index]["title"]}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ]),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color: data[index]["gender"]
                                    ? Colors.blueAccent[100]
                                    : Colors.red[200],
                                size: 11,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Icon(
                                Icons.remove_red_eye_outlined,
                                size: 14,
                              ),
                              Text(
                                "${data[index]["views"]}",
                                textAlign: TextAlign.center,
                              ),
                              Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 14,
                              ),
                              Text(
                                "${data[index]["count_likes"]}",
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text("${data[index]["count_dislikes"]}"),
                              Icon(
                                Icons.thumb_down_alt_outlined,
                                size: 14,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              TimerBuilder.periodic(
                                Duration(seconds: 3),
                                builder: (context) => Text(
                                  "${TimeUtil.timeAgo(milliseconds: DateTime.parse(data[index]["created_at"]).millisecondsSinceEpoch)}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          trailing: data[index]["image"] != null
                              ? AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      image: DecorationImage(
                                        image: ExtendedImage.network(
                                          data[index]["image"],
                                          fit: BoxFit.cover,
                                        ).image,
                                      ),
                                    ),
                                  ),
                                )
                              : null),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          )),
    );
  }
}
