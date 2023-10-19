import 'package:chats/utils/alert.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  PostDetail({super.key, required int this.pk, required String this.title});
  int pk;
  String title;
  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  void initState() {
    widget.pk;
    widget.title;
    super.initState();
  }

  void getdialog(context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("title"),
          content: Text("center content"),
          actions: [
            Container(
              child: ElevatedButton(
                child: Text("닫기"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            DropdownButton<String>(
              // value: list.first,
              icon: Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ),
              elevation: 16,
              // underline: Container(
              //   height: 2,
              //   color: Colors.deepPurpleAccent,
              // ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                // setState(() {
                //   dropdownValue = value!;
                // });
                if (value == "신고하기") {
                  showAlert(context, widget.pk);
                }
              },
              items:
                  ["신고하기", "취소"].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [Text("${widget.pk}"), Text("${widget.title}")],
          ),
        ));
  }
}
