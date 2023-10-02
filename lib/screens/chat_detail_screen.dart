import 'package:chats/apis/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatDetail extends StatefulWidget {
  ChatDetail({super.key, this.id, this.title, this.timestamp});
  late final id, title, timestamp;
  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  var repository = UserRepository();
  // late final content
  String? content;

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO : ADD ARGUMENTS
    FirebaseFirestore.instance
        .collection("chats")
        .doc()
        .snapshots()
        .listen((event) => event.data());

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "${widget.title}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text("${widget.id}"),
                  ),
                  Expanded(
                    child: Text(
                      "${widget.timestamp}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text("$content"),
              SizedBox(
                height: 120,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  child: Icon(
                    Icons.thumb_up_alt_outlined,
                  ),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(30)),
                ),
                Container(
                  child: Icon(Icons.thumb_down_alt_outlined),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(30)),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 12,
                color: Colors.black12.withAlpha(20),
              ),
              Placeholder(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      repository.comment({
                        "id": widget.id,
                        "comment": _controller.text.trim()
                      });
                      _controller.clear();
                    },
                    icon: Icon(Icons.send),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
