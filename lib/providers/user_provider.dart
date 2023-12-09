import 'package:flutter/material.dart';
import '../utils/request.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel();
  int? _point;
  get user => _user;
  get thumbnail => _user.thumbnail;
  get point => _point;

  UserProvider() {
    _setUserModel().then((_) => notifyListeners());
  }

  Future<void> _setUserModel() async {
    return await DefaultRequest.get(path: "/users/info").then((json) {
      print(json);
      this._point = json.remove("point");
      this._user = UserModel.fromJson(json);
    });
  }

  Map<String, dynamic>? _options;
  Map<String, dynamic>? get options => _options;
  set setOptions(options) => _options = options;

  List<dynamic>? _pending;
  bool? _is_pending;
  get pending => _pending;
  get is_pending => _is_pending;
  set upadatePendingImage(List images) {
    _pending = images;
    _is_pending = true;
  }

  Future setUploadImage() async {
    if (pending?.isNotEmpty ?? false) return _pending;
    await DefaultRequest.get(path: "/images/upload").then((value) {
      var values = value.remove("pending");
      this._pending = values ??
          (List.generate(6, (index) => null, growable: false)
            ..[0] = thumbnail
            ..setAll(1,
                this._user.detail?.more ?? List.generate(5, (index) => null)));
      this._is_pending = values?.isNotEmpty ?? false;
      notifyListeners();
    });
    return _pending;
  }
}

class UserModel {
  late final String? thumbnail;
  late final String? name;
  UserDetailModel? detail;

  UserModel({
    String? this.thumbnail,
    String? this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'] ?? "", thumbnail: json['thumbnail'] ?? "");
  }

  set setDetail(Map<String, dynamic> json) =>
      this.detail = UserDetailModel.fromJson(json);
}

class UserDetailModel {
  late final Map<String, dynamic> profile;
  late final Map<String, dynamic> bio;
  late final List<dynamic> more;
  late final double? height;
  late final String? job;
  late final String? location;

  UserDetailModel({
    required Map<String, dynamic> this.profile,
    required Map<String, dynamic> this.bio,
    required List<dynamic> this.more,
    required double? this.height,
    required String? this.job,
    required String? this.location,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
        profile: json["profile"],
        bio: json["bio"],
        more: json["more"],
        height: json["height"],
        job: json["job"],
        location: json["location"]);
  }
}
