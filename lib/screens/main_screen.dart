import 'package:chats/components/user_notification.dart';
import 'package:chats/providers/init_provider.dart';
import 'package:chats/screens/party_screen.dart';
import 'package:chats/screens/post_screen.dart';
import 'package:chats/screens/profile_screen.dart';
import 'package:chats/screens/service_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';
  final docRef = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("notification");
  var fsListener;
  var init;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init = context.read<Init>();
      print("init");
      checkUserState();
      fsListener = docRef.snapshots().listen(_fsTransformer);
    });
  }

  _fsTransformer(QuerySnapshot col) async {
    print(col);
    if (init.isInit) {
      init.setRepository = col.docs.map((e) => e.data() as Map).toList();
      print("done");
    }
    // col.docs.forEach((e) => _noteRepository.add((e.data() as Map)));
    else {
      for (DocumentChange change in col.docChanges) {
        if (change.type case DocumentChangeType.added) {
          Map data = change.doc.data() as Map;
          init.addRepository = data;
          overlayTransform(context, data["note"]);
        }
      }
    }
    print(init.getRepository);
  }

  checkUserState() async {
    userInfo = await storage.read(key: 'token');
    if (userInfo == null) {
      print('로그인 페이지로 이동');
      // Navigator.pushNamed(context, '/logout');
    } else {}
  }

  logout() async {
    storage.delete(key: "token");
    clearDiskCachedImages();
    clearMemoryImageCache();
    DefaultCacheManager().emptyCache();
  }

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Service(),
    Party(),
    Post(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_outlined), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_outlined), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.question_answer_outlined), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz_outlined), label: ""),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.brown[400],
          onTap: _onItemTapped,
        ));
  }
}
