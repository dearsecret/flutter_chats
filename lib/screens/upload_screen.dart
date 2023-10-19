import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  late List<dynamic> imageList;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final storageRef = FirebaseStorage.instance.ref();
  bool isChanged = false;
  bool isLoading = false;
  Set deleteSet = {};
  int index = 0;

  @override
  void initState() {
    imageList = context.read<UserProfileProvider>().images;
    if (imageList.isNotEmpty) {
      print("downloaded Provider's data");
    }
    super.initState();
  }

  pickImage(int index) async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageList[index] = File(pickedImage.path);
      });
      isChanged = true;
    }
  }

  Future putImages() async {
    print("uploading images");
    setState(() {
      isLoading = true;
    });
    await Future.wait(imageList.indexed.map((e) async => uploadTask(e)));
    isLoading = false;
  }

  Future uploadTask(element) async {
    var (i, data) = element;
    print("$i/${imageList.length}");
    final userProfileRef = storageRef.child("users/$userId/$i.jpg");
    if (data is File) {
      await userProfileRef.putFile(data);
      print("$i uploded success");
    } else if (deleteSet.contains(i)) {
      await userProfileRef.delete();
      print("$i delete");
    }
  }

  showImage(var e) {
    if (e is File) {
      return ExtendedImage.file(
        e,
        fit: BoxFit.cover,
      );
    } else {
      return ExtendedImage.network(
        e,
        fit: BoxFit.cover,
        cache: true,
      );
    }
  }

  // TODO: make Validation
  // bool tryValidation() {
  //   if (imageList[0] ==null) {
  //     return false;
  //   } else if (imageList.where((element) => element != null).length < 3){
  //     return false;
  //   }
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            isChanged
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
      body: SafeArea(
        child: Container(
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
                                    index = i;
                                  });
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: index == i ? 3 : 1,
                                        color: index == i
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
                  index: index,
                  children: <Widget>[
                    for (var i in imageList)
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: GestureDetector(
                          onTap: () {
                            pickImage(index);
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
                                              imageList[index] = null;
                                            });
                                            deleteSet.add(index);
                                            isChanged = true;
                                          },
                                        ),
                                      )
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
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          child: Text(
                            "저장",
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            // TODO : save listImage to FIREBASE STORAGE
                            isLoading
                                ? null
                                : putImages().then(
                                    (value) => Navigator.of(context).pop());
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
