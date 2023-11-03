import 'package:chats/providers/party_provider.dart';
import 'package:chats/providers/post_provider.dart';
import 'package:chats/providers/user_profile_provider.dart';
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
            create: (context) => UserProfileProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => PartyProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: TextTheme(
              titleMedium: TextStyle(color: Colors.brown[400]),
              titleLarge: TextStyle(color: Colors.brown[200]),
            ),
            textSelectionTheme:
                TextSelectionThemeData(cursorColor: Colors.brown[600]),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.brown[300],
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
