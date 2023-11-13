import 'dart:convert';

import 'package:chats/components/logout_button.dart';
import 'package:chats/providers/user_profile_provider.dart';
import 'package:chats/screens/profile_detail_screen.dart';
import 'package:chats/screens/profile_preview.dart';
import 'package:chats/utils/alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/profile_menu.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map data = {};
  getProfile() async {
    final token = await storage.read(key: "token");
    http.Response response = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/v1/users/me"),
      headers: {"Authorization": token!, "Content-Type": "Application/json"},
    );
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(utf8.decode(response.bodyBytes));
      });
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var thumbnail = context
        .select<UserProfileProvider, dynamic>((provider) => provider.thumbnail);

    return SafeArea(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<UserProfileProvider>().getImages();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12),
                  Stack(
                    children: [
                      if (thumbnail == null)
                        FutureBuilder(
                          future:
                              context.read<UserProfileProvider>().getImages(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState !=
                                    ConnectionState.waiting) {
                              return CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 7,
                                backgroundImage: ExtendedImage.network(
                                  snapshot.data,
                                  color: null,
                                  cache: true,
                                ).image,
                                backgroundColor: Colors.brown[100],
                              );
                            } else {
                              return CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 7,
                                backgroundColor: Colors.grey[200],
                              );
                            }
                          },
                        ),
                      if (thumbnail != null)
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7,
                          backgroundImage: ExtendedImage.network(
                            thumbnail,
                            cache: true,
                            color: null,
                          ).image,
                          backgroundColor: Colors.brown[100],
                        ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25))),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfilePreview()));
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text("${data["name"]}"),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {},
                      child: Text("포인트 ${data["point"]}"),
                    ),
                  ),
                  // Text("${context.read<UserProvider>().name}"),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileDetail(),
                          ));
                        },
                        child: MenuItem(
                            title: "프로필",
                            iconData: Icons.contact_page_outlined),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: MenuItem(
                              title: "친구초대", iconData: Icons.email_outlined)),
                      TextButton(
                          onPressed: () {},
                          child: MenuItem(
                              title: "문의하기",
                              iconData: Icons.phone_in_talk_outlined)),
                      TextButton(
                          onPressed: () {},
                          child: MenuItem(
                              title: "설정", iconData: Icons.settings_outlined)),
                      SignOut()
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
