import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final storage = FlutterSecureStorage();
  static get getToken async => await storage.read(key: "token");
}
