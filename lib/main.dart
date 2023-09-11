import 'package:chats/components/jwt_login.dart';
import 'package:flutter/material.dart';
import 'package:chats/components/upload_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// flutter pub add flutter_secure_storage
// Android , MacOS Linux 는 별도의 설정이 필요합니다.
// flutter pub add http

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();

  addKey(String value) async {
    await storage.write(key: "jwt", value: value);
  }

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  dynamic userInfo = '';

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key: 'jwt');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      Navigator.pushNamed(context, '/main');
    } else {
      print('로그인이 필요합니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          titleMedium: TextStyle(color: Colors.brown[500]),
          titleLarge: TextStyle(color: Colors.brown[400]),
        ),
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: Colors.brown[200]),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.brown[200],
          secondary: Colors.green,
        ),
      ),
      // home: const LogOut());
      home: Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.unarchive),
          ),
          body: const Column(
            children: [
              AddImage(),
              // JWTLogin(addKey, username: username, password: password)
            ],
          )),
    );
  }
}
