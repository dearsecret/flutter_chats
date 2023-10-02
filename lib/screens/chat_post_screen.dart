import 'package:flutter/material.dart';

import '../apis/user_repository.dart';

class ChatPost extends StatefulWidget {
  const ChatPost({super.key});

  @override
  State<ChatPost> createState() => _ChatPostState();
}

class _ChatPostState extends State<ChatPost> {
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
                  repository.chat({
                    "title": title,
                    "content": content,
                  });
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
