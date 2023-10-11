import 'package:chats/components/appbars/default_appbar.dart';
import 'package:chats/screens/party_screen.dart';
import 'package:chats/screens/posts_write_screen.dart';
import 'package:chats/screens/profile_screen.dart';
import 'package:chats/screens/service_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../apis/user_repository.dart';
import 'chat_post_screen.dart';
import 'chat_screen.dart';
// provider => analysis_options.yaml needs to delete "include"
// flutter_secure_storage needs to settings 안드로이드

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  logout() async {
    storage.delete(key: "token");
    clearDiskCachedImages();
    clearMemoryImageCache();
    context.read<UserProvider>().deleteInfo();
    Navigator.pushNamed(context, '/');
    DefaultCacheManager().emptyCache();
  }

  checkUserState() async {
    userInfo = await storage.read(key: 'token');
    if (userInfo == null) {
      print('로그인 페이지로 이동');
      Navigator.pushNamed(context, '/logout');
    } else {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
    final user = Provider.of<UserProvider>(context, listen: false);
    final info = Provider.of<UserProvider>(context, listen: false);
    user.fetchUser();
    info.fetchUserInfo();
    print("user info fetched");
  }

  int _selectedIndex = 0;

  List<Widget?> _appbarOptions = <Widget?>[
    null,
    null,
    DefaultAppbar(),
    null,
  ];
  List<Widget> _widgetOptions = <Widget>[
    Service(),
    Party(),
    Chat(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  Widget? switchFloatingButton(_selectedIndex) {
    Widget newButton = Container();
    switch (_selectedIndex) {
      case 0:
        break;
      case 1:
        newButton = Align(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PostWrite()));
            },
            child: Icon(Icons.border_color),
            backgroundColor: Colors.black,
          ),
          alignment: Alignment(0.95, 0.95),
        );
        break;
      case 2:
        newButton = Align(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChatPost()));
            },
            child: Icon(Icons.border_color),
            backgroundColor: Colors.black,
          ),
          alignment: Alignment(0.95, 0.95),
        );
        break;
      case 3:
        break;
    }
    return newButton;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbarOptions.elementAt(_selectedIndex) == null
            ? null
            : PreferredSize(
                preferredSize: AppBar().preferredSize,
                child: _appbarOptions.elementAt(_selectedIndex)!),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.psychology_alt_outlined), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_outlined), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.question_answer_outlined), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined), label: ""),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.brown[400],
          onTap: _onItemTapped,
        ),
        floatingActionButton: switchFloatingButton(_selectedIndex));
  }
}
