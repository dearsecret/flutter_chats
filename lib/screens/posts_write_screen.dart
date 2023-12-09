import 'dart:io';

import 'package:chats/utils/request.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class PostWrite extends StatefulWidget {
  const PostWrite({super.key});

  @override
  State<PostWrite> createState() => _PostWriteState();
}

class _PostWriteState extends State<PostWrite> {
  var _formKey = GlobalKey<FormState>();
  String title = "";
  String content = "";

  _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  final FlutterSecureStorage storage = FlutterSecureStorage();
  sendPost() async {
    Map data = {"title": title, "content": content};
    if (file != null) {
      final ref = await FirebaseStorage.instance
          .ref()
          .child("posts/${DateTime.now().microsecondsSinceEpoch}");
      await ref.putFile(file!);
      data["image"] = await ref.getDownloadURL();
      print(data["image"]);
    }
    DefaultRequest.post(path: "/chats/post", data: data);
  }

  File? file;
  putImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        file = File(pickedImage.path);
      });
    }
  }

  bool isChecked = false;
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
              if (file != null) Image.file(file!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        putImage();
                      },
                      icon: Icon(Icons.add_photo_alternate_outlined)),
                  Checkbox(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black),
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      }),
                  IconButton(
                    onPressed: () {
                      _tryValidation();
                      sendPost();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
