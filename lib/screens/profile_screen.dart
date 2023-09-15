import 'package:chats/components/profile_menu.dart';
import 'package:chats/components/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../apis/user_repository.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width / 7,
                // backgroundImage: ,
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
                    onPressed: () {},
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
          // Text("${context.watch<UserProvider>()}"),
          Text("${context.read<UserProvider>().name}"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddImage()));
                  },
                  child: MenuItem(
                      title: "프로필", iconData: Icons.contact_page_outlined),
                ),
                TextButton(
                    onPressed: () {},
                    child: MenuItem(
                        title: "친구초대", iconData: Icons.email_outlined)),
                TextButton(
                    onPressed: () {},
                    child: MenuItem(
                        title: "문의하기", iconData: Icons.phone_in_talk_outlined)),
                TextButton(
                    onPressed: () {},
                    child: MenuItem(
                        title: "설정", iconData: Icons.settings_outlined)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
