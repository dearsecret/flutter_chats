import 'package:chats/apis/user_repository.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    getCachedPhotos();
  }

  void _uploadImage(String uploadUrl, File file, String token) async {
    var request = http.MultipartRequest("POST", Uri.parse(uploadUrl));
    request.fields["requireSignedURLs"] = "true";
    var pic = await http.MultipartFile.fromPath("file", file.path);
    request.files.add(pic);
    var response = await request.send();
    if (!(response.statusCode).toString().startsWith("4")) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var result = jsonDecode(responseString)["result"]["variants"][0];
      Map body = {"url": result};
      // var body = jsonEncode(body);
      // Flutter Secure Storage JWT 추가 필요
      await http
          .put(Uri.parse('http://127.0.0.1:8000/api/v1/images/upload'),
              headers: {
                "Authorization": "$token",
                // "Content-type": "application/json"
              },
              body: body)
          .then((resp) {
        if (resp.statusCode == 200) {
          print("success");
        }
      });
    }
  }

  void _getUpload(pickImage) async {
    var url = Uri.parse(
      'http://127.0.0.1:8000/api/v1/images/upload',
    );
    var token = await storage.read(key: "token");
    await http.post(url, headers: {"Authorization": "$token"}).then((resp) {
      if (resp.statusCode == 200) {
        String link = jsonDecode(resp.body)["uploadUrl"];

        _uploadImage(link, pickImage, token!);
      }
    }).catchError((error) => print(error));
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

  int? selected;
  // List<dynamic> something = [];
  File? file;
  void getCachedPhotos() async {
    await context.read<UserProvider>().photos.map((e) async {
      var fileInfo = await DefaultCacheManager().getFileFromCache("$e");
      print("$fileInfo");
    });
    var fileInfo = await DefaultCacheManager().getFileFromCache("0");
    if (fileInfo != null) {
      file = fileInfo.file;
      // something.add(fileInfo.file);
      // print("${fileInfo.file}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ...context.read<UserProvider>().cachedImage.map(
                      (e) => Expanded(
                        child: Container(
                          child: Image.file(e),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ThemeData().primaryColor,
                          ),
                        ),
                      ),
                    )
              ],
            ),
            // Text("${file.path}"),
            // Expanded(child: Text("${fileInfo}")
            // child: ExtendedImage.network(
            //   "0",
            //   border: Border.all(color: Colors.red, width: 1.0),
            //   shape: BoxShape.rectangle,
            //   borderRadius: BorderRadius.all(Radius.circular(10)),
            //   loadStateChanged: (ExtendedImageState state) {
            //     switch (state.extendedImageLoadState) {
            //       case LoadState.loading:
            //         break;
            //       case LoadState.completed:
            //         break;
            //       case LoadState.failed:
            //         break;
            //       case LoadState.loading:
            //     }
            //     return null;
            //   },
            // ),
            // ),
            Container(
              margin: EdgeInsets.all(20),
              child: GestureDetector(
                onTap: _pickImage,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.withAlpha(80),
                          image: _image != null
                              ? DecorationImage(
                                  image: FileImage(_image!), fit: BoxFit.cover)
                              : null),
                      child: _image != null
                          ? null
                          : const Icon(Icons.add_a_photo_outlined)),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    _getUpload(_image);
                  },
                  icon: const Icon(Icons.send)),
            ),
          ],
        ),
      ),
    );
  }
}
