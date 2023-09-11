import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  void _uploadImage(String uploadUrl, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(uploadUrl));
    request.fields["requireSignedURLs"] = "true";
    var pic = await http.MultipartFile.fromPath("file", file.path);
    request.files.add(pic);
    var response = await request.send();
    if (!(response.statusCode).toString().startsWith("4")) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var result = jsonDecode(responseString)["result"]["variants"][0];
      Map data = {"url": result};
      var body = jsonEncode(data);
      // Flutter Secure Storage JWT 추가 필요
      await http
          .put(Uri.parse('http://127.0.0.1:8000/api/v1/images/upload'),
              headers: {"content-type": "application/json"}, body: body)
          .then((resp) {
        if (resp.statusCode == 200) {
          print("success");
        }
      });
    }
  }

  void _getUpload(pickImage) async {
    // if (pickImage != null) {
    var url = Uri.parse(
      'http://127.0.0.1:8000/api/v1/images/upload',
    );
    var response = await http
        .post(
      url,
    )
        .then((resp) {
      if (resp.statusCode == 200) {
        String link = jsonDecode(resp.body)["uploadUrl"];

        _uploadImage(link, pickImage);
      }
    }).catchError((error) => print(error));

    // }
  }

  File? _image;
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);
    setState(() {
      // if (pickedImageFile != null) {
      _image = File(pickedImageFile!.path);
      // }
    });
    // widget.addImageFunc(pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.withAlpha(100),
                    // image : Image.file(_image!)),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!), fit: BoxFit.cover)
                        // image: Image.file(_image!), fit: BoxFit.cover)
                        : null),
                child: _image != null
                    ? null
                    : const Icon(Icons.add_a_photo_outlined)),
          ),
        ),
        IconButton(
            onPressed: () {
              _getUpload(_image);
            },
            icon: const Icon(Icons.send))
      ],
    );
  }
}
