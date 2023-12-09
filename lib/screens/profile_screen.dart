import 'package:chats/components/logout_button.dart';
import 'package:chats/screens/profile_detail_screen.dart';
import 'package:chats/screens/profile_preview_screen.dart';
import 'package:chats/screens/service_detail_screen.dart';
import 'package:chats/screens/upload_screen.dart';
import 'package:chats/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/profile_menu.dart';
import '../providers/user_provider.dart';
import '../utils/contacts.dart';

class Profile extends StatefulWidget {
  Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<UserProvider>();
    return SafeArea(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return RefreshIndicator(
          onRefresh: () async {},
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
                      Hero(
                        tag: "",
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: provider.thumbnail == null
                              ? null
                              : CustomImage.createProvider(provider.thumbnail),
                        ),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ServiceDetail(user: provider.user),
                                ),
                              );
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
                  Text("${provider.user.name ?? ''}"),
                  Container(
                    child: ElevatedButton(
                      child: Text("포인트 ${provider.point ?? 0}"),
                      onPressed: () {},
                    ),
                  ),
                  Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Preview(),
                            ));
                          },
                          child: MenuItem(
                              title: "프로필 관리",
                              iconData: Icons.contact_page_outlined)),
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
                          onPressed: () {
                            getContacts(context);
                            // final values = await getContacts(context);

                            setState(() {});
                          },
                          child: MenuItem(
                              title: "연락처 차단",
                              iconData: Icons.add_reaction_outlined)),
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
