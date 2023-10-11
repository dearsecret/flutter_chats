import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  PostDetail({super.key, required String docId, required String docTitle});
  String? docId, docTitle;
  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  void initState() {
    // TODO: implement initState
    widget.docId;
    widget.docTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: [Text("${widget.docTitle}"), Text("${widget.docId}")]),
    );
  }
}
