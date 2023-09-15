import 'package:chats/screens/profile_screen.dart';
import 'package:chats/screens/service_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../apis/user_repository.dart';
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
    // int val = await getCachedSizeBytes();
    // print("${val}");
    // clearMemoryImageCache();
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
    info..fetchUserInfo();
    print("user info fetched");
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  List<Widget> _widgetOptions = <Widget>[
    Service(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2
          ? AppBar(
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.abc_outlined),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'logout',
                  onPressed: () {
                    logout();
                  },
                )
              ],
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline), label: "home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_answer_outlined), label: "chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: "user"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown[400],
        onTap: _onItemTapped,
      ),
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
    );
  }
}
