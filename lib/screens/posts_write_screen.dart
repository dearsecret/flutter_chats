import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../apis/user_repository.dart';

class PostWrite extends StatefulWidget {
  const PostWrite({super.key});

  @override
  State<PostWrite> createState() => _PostWriteState();
}

class _PostWriteState extends State<PostWrite> {
  var repository = UserRepository();
  var _formKey = GlobalKey<FormState>();
  String title = "";
  String content = "";

  _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  // String uid,
  // String picture,
  void writeNewPost(String username, String title, String body) async {
    final postData = {
      // 'author': username,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      // 'authorPic': picture,
      'title': title,
      'timestamp': ServerValue.timestamp,
      // 'body': body,
    };
    final ref = FirebaseDatabase.instance.ref().child('posts').push();
    ref.set(postData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: ValueKey(1),
                      validator: (String? value) {
                        if (value!.trim().length < 4) {
                          return "올바르지 않은 양식입니다.";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          title = value!;
                        });
                      },
                      maxLines: null,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TextFormField(
                  key: ValueKey(2),
                  validator: (String? value) {
                    if (value!.trim().length < 4) {
                      return "올바르지 않은 양식입니다.";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      content = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      content = value!;
                    });
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _tryValidation();
                  // repository.chat({
                  //   "title": title,
                  //   "content": content,
                  // });
                  // TODO 데이터 구조화 && uid 설정
                  writeNewPost("TEST", title, content);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
