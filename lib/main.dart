import 'package:chats/providers/daily_provider.dart';
import 'package:chats/providers/init_provider.dart';
import 'package:chats/providers/party_provider.dart';
import 'package:chats/providers/post_provider.dart';
import 'package:chats/providers/user_provider.dart';
import 'package:chats/screens/logout_screen.dart';
import 'package:chats/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// flutter pub add flutter_secure_storage
// Android , MacOS Linux 는 별도의 설정이 필요합니다.
// flutter pub add http

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => PostProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => DailyProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => PartyProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => Init(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme:
                BottomNavigationBarThemeData(backgroundColor: Colors.white),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.brown[300],
              surfaceTint: Colors.white,
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const MyProfile();
              }
              return const LogOut();
            },
          ),
        ));
  }
}
