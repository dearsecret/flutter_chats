import 'package:chats/providers/post_provider.dart';
import 'package:chats/screens/post_detail_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late ScrollController _controller;
  bool isFetched = false;
  bool isMore = true;
  bool isLoading = false;

  @override
  void initState() {
    _controller = new ScrollController()..addListener(_scorollListener);
    super.initState();
  }

  _scorollListener() {
    if (isLoading | !isMore) return;
    if (_controller.offset == _controller.position.maxScrollExtent) {
      isLoading = true;
      context.read<PostProvider>().getMore();
      isLoading = false;
    }
  }

  int? selectedKey;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();
    final data = provider.data;
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      controller: _controller,
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                                image: ExtendedImage.network(
                              data[index]["image"],
                              fit: BoxFit.cover,
                            ).image),
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
    );
  }
}
