import 'package:flutter/material.dart';
import 'package:chats/apis/user_repository.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../components/image_item.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String _selectedIndex = "0";

  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().clearImages();
    context.read<UserProvider>().initializeImage;
    print("provider cleaned!");
    print("tmp 폴더 삭제 방법 찾아보기");
    print("image 할당됨");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    clearMemoryImageCache();

    super.dispose();
  }

  File? image;
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      image = File(pickedImageFile!.path);
      context.read<UserProvider>().selectedImage["${_selectedIndex}"] = image;
      print("${context.read<UserProvider>().selectedImage}");
    });
  }

  void _getIndex(int index) {
    _selectedIndex = "${index}";
    print("${context.read<UserProvider>().selected}");
  }

  @override
  Widget build(BuildContext context) {
    context.select<UserProvider, Map<String, dynamic>>(
        (provider) => provider.selectedImage);

    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              ...List<Widget>.generate(
                6,
                (index) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _getIndex(index);
                      setState(() {
                        context.read<UserProvider>().selected = index;
                      });
                    },
                    child: ImageItem(
                      index: "${index}",
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: _pickImage,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                  margin: const EdgeInsets.all(10),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: context
                          .watch<UserProvider>()
                          .selectedImage
                          .containsKey(_selectedIndex)
                      ? Stack(children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            // child:
                            // Image(
                            //   image: images[_selectedIndex].image,
                            // ),
                            // child: Placeholder()
                            child: context
                                .read<UserProvider>()
                                .make_iamge(_selectedIndex, null)!,
                          ),
                          Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.delete_outline_rounded),
                                onPressed: () {
                                  context
                                      .read<UserProvider>()
                                      .removeElement(_selectedIndex);
                                },
                              ))
                        ])
                      : Icon(Icons.add)),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {
                UserRepository()
                    .getUpload(context.read<UserProvider>().selectedImage);
              },
              icon: const Icon(Icons.send)),
        ),
      ]),
    );
  }
}
