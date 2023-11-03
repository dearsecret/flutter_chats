import 'dart:convert';
import 'dart:io';
import 'package:chats/utils/alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PartyWrite extends StatefulWidget {
  const PartyWrite({super.key});

  @override
  State<PartyWrite> createState() => _PartyWriteState();
}

class _PartyWriteState extends State<PartyWrite> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";

  bool _enableBtn = false;

  Future uploadServer() async {
    setState(() {
      isLoading = true;
    });
    final token = await storage.read(key: "token");
    final photo = await uploadPhoto();
    http.Response response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/v1/meetings/init"),
        headers: {"Authorization": token!, "Content-Type": "Application/json"},
        body: jsonEncode({
          "title": _title,
          "content": _content,
          "photo": photo,
        }));
    print(response);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    }
  }

  Future<String> uploadPhoto() async {
    final ref = FirebaseStorage.instance
        .ref("party/${DateTime.now().microsecondsSinceEpoch}");
    await ref.putFile(selectedFile!);
    return await ref.getDownloadURL();
  }

  File? selectedFile;
  Future pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedFile = File(pickedImage.path);
      });
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {
              _enableBtn = _formKey.currentState!.validate();
            }),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              pickImage();
                            },
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                child: selectedFile != null
                                    ? null
                                    : Center(child: Text("필수")),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  image: selectedFile != null
                                      ? DecorationImage(
                                          image: FileImage(selectedFile!),
                                          fit: BoxFit.cover)
                                      : null,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Divider(
                            thickness: 1.5,
                          ),
                          Column(
                            children: [
                              TextFormField(
                                key: ValueKey(1),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "제목을 입력하시길 바랍니다.";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _title = value;
                                },
                                onSaved: (newValue) {},
                                maxLines: null,
                              ),
                              TextFormField(
                                key: ValueKey(2),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _content = value;
                                },
                                onSaved: (newValue) {},
                                maxLines: null,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading == false)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _enableBtn && selectedFile != null
                                    ? () {
                                        uploadServer();
                                      }
                                    : null,
                                child: Text("저장하기"),
                              ),
                            )
                          else
                            Center(
                              child: CircularProgressIndicator(),
                            )
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
