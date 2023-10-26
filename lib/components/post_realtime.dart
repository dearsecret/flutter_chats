import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    if (isLoading || !isMore) return;
    isLoading = true;
    context.read<PostProvider>().getMore();
    isLoading = false;
  }

  int? selectedKey;

  Future _refresh() async {}
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();
    final data = provider.data;
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
        child: ListView.separated(
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
                            pk: data[index]["pk"], title: data[index]["title"]),
                      ),
                    );
                  });
                },
                child: ListTile(
                    leading: Text("${data[index]["pk"]}"),
                    title: Text(
                      "${data[index]["title"]}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${data[index]["created_at"]}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
              return isMore
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: Text("데이터가 존재하지 않습니다."),
                    );
            }
          },
        ),
      ),
    );
  }
}
