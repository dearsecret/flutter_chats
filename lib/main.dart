import 'package:chats/apis/user_repository.dart';
import 'package:chats/screens/logout_screen.dart';
import 'package:chats/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  FlutterSecureStorage.setMockInitialValues({});
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
        ChangeNotifierProvider(create: (context) => UserProvider()),
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
        initialRoute: "/",
        routes: {
          "/": (context) => const LogOut(),
          "/main": (context) => const MyProfile(),
        },
      ),
    );
  }
}
