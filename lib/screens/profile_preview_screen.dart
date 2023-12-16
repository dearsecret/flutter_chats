import 'package:chats/components/profile_menu.dart';
import 'package:chats/providers/user_provider.dart';
import 'package:chats/screens/profile_detail_screen.dart';
import 'package:chats/screens/upload_screen.dart';
import 'package:chats/utils/request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Preview extends StatefulWidget {
  Preview({super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  Map<String, dynamic>? _options;
  @override
  void initState() {
    super.initState();
    // _options = context.read<UserProvider>().options;
  }

  Future _getOptions() async {
    if (_options?.isNotEmpty ?? false) return _options;
    _options = await DefaultRequest.get(path: "/users/profile");
    context.read<UserProvider>().setOptions = _options;
    print("set options' provider");
    return _options;
  }

  getDetail() async {
    return context.read<UserProvider>().user.detail ??=
        await DefaultRequest.post(
      path: "/users/info",
      // data: {"updated_at": widget.updated_at}
    ).then((value) {
      return UserDetailModel.fromJson(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) Navigator.of(context).pop();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(),
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: FutureBuilder(
                  future: getDetail(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return CircularProgressIndicator();
                    else
                      return Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileDetail(),
                              ));
                            },
                            child: MenuItem(
                                title: "프로필 정보 변경",
                                iconData: Icons.contact_page_outlined),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UploadImage(),
                              ));
                            },
                            child: MenuItem(
                                title: "프로필 사진 변경",
                                iconData: Icons.contact_page_outlined),
                          ),
                          // FutureBuilder(
                          //     future: Future.delayed(
                          //         Duration(microseconds: 200),
                          //         () => _getOptions()),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting)
                          //         return CircularProgressIndicator();
                          //       if (snapshot.hasData) {
                          //         return GridView(
                          //             padding: EdgeInsets.symmetric(
                          //                 vertical: 15, horizontal: 20),
                          //             physics: NeverScrollableScrollPhysics(),
                          //             shrinkWrap: true,
                          //             gridDelegate:
                          //                 SliverGridDelegateWithFixedCrossAxisCount(
                          //                     crossAxisCount: 2,
                          //                     crossAxisSpacing: 10,
                          //                     mainAxisSpacing: 10,
                          //                     childAspectRatio: 5 / 1),
                          //             children: snapshot.data.entries
                          //                 .map<Widget>((e) => SelectedButton(
                          //                       title: e.key,
                          //                       list: e.value,
                          //                     ))
                          //                 .toList());
                          //       } else {
                          //         return Text("sad");
                          //       }
                          //     })
                        ],
                      );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectedButton extends StatefulWidget {
  SelectedButton({
    required String this.title,
    required List this.list,
    // required Map this.map,
  }) : this.key = ValueKey(title);

  late final ValueKey key;
  late final String title;
  late final List list;
  // late final Map map;

  @override
  State<SelectedButton> createState() => _SelectedButtonState();
}

class _SelectedButtonState extends State<SelectedButton> {
  String? selectedValue;
  @override
  void initState() {
    // selectedValue =
    //     context.read<UserProvider>().user.detail.profile["${widget.title}"] ??
    //         widget.list[0];
    super.initState();
  }

  _convertOptions(String key) {
    switch (key) {
      case "region":
        return "\u{1F4CD} 지역 :";
      case "school":
        return "\u{1F393} 학력 :";
      case "religion":
        return "\u{1F64F} 종교 :";
      case "policy":
        return "\u{1F3AD} 정치 :";
      case "smoke":
        return "\u{1F6AC} 흡연 :";
      case "drink":
        return "\u{1F377} 음주 :";
      case "drive":
        return "\u{1F698} 차량 :";
      case "weight":
        return "\u{1F4AA} 체형 :";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            dropdownColor: Colors.white,
            key: widget.key,
            validator: (value) {
              if (value == null || value.toString().trim().isEmpty) return "필수";
              return null;
            },
            onSaved: (newValue) {
              // (widget.map.putIfAbsent("profile", () => {})
              //     as Map)[widget.title] = widget.list.indexOf(newValue);
            },
            onChanged: (value) {
              setState(() {
                selectedValue = value! as String;
              });
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            iconSize: 0,
            elevation: 0,
            decoration: InputDecoration(
                isCollapsed: true,
                prefixIcon: Text("${_convertOptions(widget.title)}  "),
                border: InputBorder.none),
            value: selectedValue,
            items: widget.list
                .map((e) => DropdownMenuItem(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                      ),
                      value: e,
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
