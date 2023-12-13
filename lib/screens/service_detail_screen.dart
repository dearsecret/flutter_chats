import 'package:chats/utils/request.dart';
import 'package:flutter/material.dart';
import 'package:chats/providers/user_provider.dart';
import 'package:chats/utils/custom_utils.dart';
import 'package:chats/utils/image.dart';

class ServiceDetail extends StatefulWidget {
  late final UserModel user;
  late final Map? data;
  ServiceDetail({super.key, required UserModel this.user, Map? this.data});
  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  var thumbnail;
  late bool _isMe;
  @override
  void initState() {
    _isMe = widget.data?.isEmpty ?? true;
    super.initState();
  }

  Future _getUserDetail() async {
    if (widget.user.detail != null) return widget.user.detail;
    var data = _isMe
        ? await DefaultRequest.post(
            path: "/users/info",
          )
        : await DefaultRequest.get(
            path: "/services/detail/${widget.data?["pk"]}",
          );
    widget.user.detail = UserDetailModel.fromJson(data);
    return widget.user.detail;
  }

  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<UserProvider>();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              flexibleSpace: FlexibleSpaceBar(
                background: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Hero(
                      tag: widget.data?["pk"] ?? "",
                      // tag: widget.user.created ?? "",
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: CustomImage.createProvider(
                                    widget.user.thumbnail!),
                                fit: BoxFit.cover)),
                      )),
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder(
          future: _getUserDetail(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (!_isMe)
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: Text("연락처 공개를 요청하시겠습니까?"),
                                            actions: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          foregroundColor:
                                                              Colors.grey),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("취소")),
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("요청")),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text("연락처 요청"))
                                ]),
                          ),
                      ],
                    ),
                  ),

                  SliverToBoxAdapter(
                      child: Column(
                    children: [
                      Divider(),
                      Text("\u{1F4B0} 인증 내역"),
                      DefaultTextStyle(
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 5)
                              ]),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 40),
                          child: GridView(
                              padding: EdgeInsets.all(15),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 5 / 1),
                              children: [
                                ...widget.user.detail!.profile.entries
                                    .map((e) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${CustomUtils.convertOptions(e.key)}"),
                                            Text("${e.value ?? ''}")
                                          ],
                                        ))
                              ]),
                        ),
                      ),
                      ...widget.user.detail!.more.where((e) => e != null).map(
                            (e) => Padding(
                              padding: EdgeInsets.all(20),
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Image(
                                    image: CustomImage.createProvider(e),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                      ...widget.user.detail!.bio.entries
                          .map((e) => Text("${CustomUtils.convertBio(e.key)}")),
                      SizedBox(
                        height: 200,
                      ),
                    ],
                  )),

                  // if (model == null)
                  //   SliverFillRemaining(
                  //     hasScrollBody: false,
                  //     child: Center(
                  //       child: CircularProgressIndicator(),
                  //     ),
                  //   ),
                ],
              );
          },
        ),
      ),
    );
  }
}
