import 'dart:io';
import 'package:chats/utils/request.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  List imageList = [];
  List? preList;
  bool _isChanged = false;
  bool _isLoading = false;
  Set _deleteSet = {};
  int _index = 0;

  getPictures() async {
    await context.read<UserProvider>().setUploadImage().then((value) {
      setState(() {
        imageList = value.toList();
      });
      preList = value;
    });

    return imageList;
  }

  _pickImage(int index) async {
    if (context.read<UserProvider>().is_pending) return;
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageList[index] = File(pickedImage.path);
      });
      _isChanged = true;
    }
  }

  showImage(var e) {
    if (e is File) {
      return ExtendedImage.file(
        e,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: !context.watch<UserProvider>().is_pending
                    ? null
                    : ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.srcOver),
                image: ExtendedImage.network(
                  e,
                  fit: BoxFit.cover,
                  cache: true,
                  imageCacheName: "$e",
                  cacheMaxAge: Duration(days: 7),
                ).image,
                fit: BoxFit.cover)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            !listEquals(imageList, preList)
                ? showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("변경된 사진이 저장되지 않았습니다. \n저장하시겠습니까?"),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("아니오")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("계속"))
                        ],
                      );
                    },
                  )
                : Navigator.pop(context);
            ;
          },
        ),
      ),
      body: FutureBuilder(
        future: getPictures(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return SafeArea(
              child: (imageList.isEmpty)
                  // child: (imageList.isEmpty ?? true)
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "  프로필 사진 변경",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ...imageList
                                  .asMap()
                                  .map((i, e) => MapEntry(
                                      i,
                                      Container(
                                        child: Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _index = i;
                                              });
                                            },
                                            child: Container(
                                              clipBehavior: Clip.hardEdge,
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: _index == i ? 3 : 1,
                                                    color: _index == i
                                                        ? Colors.teal
                                                        : Colors.black),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: e == null
                                                      ? Icon(Icons.add)
                                                      : showImage(e)),
                                            ),
                                          ),
                                        ),
                                      )))
                                  .values
                                  .toList()
                            ],
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Expanded(
                            flex: 2,
                            child: IndexedStack(
                              index: _index,
                              children: <Widget>[
                                for (var i in imageList)
                                  AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        _pickImage(_index);
                                      },
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: i == null ? 1 : 0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: i == null
                                            ? Icon(Icons.add)
                                            : Stack(
                                                children: [
                                                  Positioned(
                                                      right: 0,
                                                      bottom: 0,
                                                      left: 0,
                                                      top: 0,
                                                      child: showImage(i)),
                                                  if (!provider.is_pending)
                                                    Positioned(
                                                      right: 2,
                                                      top: 2,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            imageList[_index] =
                                                                null;
                                                          });
                                                          _deleteSet
                                                              .add(_index);
                                                          _isChanged = true;
                                                        },
                                                      ),
                                                    )
                                                  else
                                                    Center(
                                                      child: Text(
                                                        "회원님의 사진을 심사 중 입니다.",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: _isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : _isChanged
                                      ? ElevatedButton(
                                          child: Text(
                                            "저장",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          onPressed: provider.is_pending
                                              ? null
                                              : () {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  DefaultRequest.uploadImages(
                                                          imageList)
                                                      .then((e) => provider
                                                              .upadatePendingImage =
                                                          e["pending"])
                                                      .then((_) =>
                                                          Navigator.of(context)
                                                              .pop());
                                                },
                                        )
                                      : null,
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          }
        },
      ),
    );
  }
}
