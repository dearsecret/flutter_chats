import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/request.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double? _height;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   // context.read<UserProvider>().setOptions;
    // });
  }

  Future _refresh() async {}

  _success(e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("성공적으로 저장되었습니다.")));
  }

  Map _data = {};

  _saveData(_data) async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      _data["height"] = _height?.toInt();

      // _data.update();
      print(_data);
      // TODO ; SEND DATA FUNCTION
      await DefaultRequest.post(path: "/users/profile", data: _data)
          .then(_success, onError: (e) => print(e));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("올바른 값을 입력해주세요."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var _user =
        context.select<UserProvider, UserModel>((provider) => provider.user);
    // var _default = context.read<UserProvider>().user.detail;
    _height ??= _user.detail!.height ?? 170;
    return Scaffold(
      appBar: AppBar(actions: [
        Container(
          width: 60,
          child: InkWell(
            onTap: () {
              _saveData(_data);
            },
            customBorder: CircleBorder(),
            child: Center(
                child: Text(
              "저장",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
        )
      ]),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: _user.detail == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "프로필 정보 변경",
                              style: TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            CustomTextFormField(
                                key: ValueKey("job"),
                                initalValue: context
                                    .read<UserProvider>()
                                    .user
                                    .detail
                                    .job,
                                map: _data),
                            CustomTextFormField(
                                key: ValueKey("location"),
                                initalValue: context
                                    .read<UserProvider>()
                                    .user
                                    .detail
                                    .location,
                                map: _data)
                          ],
                        ),
                      ),
                      // // User's Height
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "\u{1F6B6} 키 : ${_height?.round()} cm",
                                  textAlign: TextAlign.start,
                                )
                              ],
                            ),
                            Slider(
                                value: _height!,
                                min: 145,
                                max: 200,
                                divisions: 200,
                                label: "${_height?.round()}cm",
                                onChanged: (value) {
                                  setState(() {
                                    _height = value;
                                  });
                                }),
                          ],
                        ),
                      ),
                      // // Profile

                      // Bio
                      ListView(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ..._user.detail!.bio.entries.map((e) => Bio(
                                key: ValueKey(e.key),
                                title: e.key,
                                initalValue: e.value,
                                map: _data))
                          ]),
                      SizedBox(
                        height: 200,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  late final ValueKey key;
  final TextInputType? inputType;
  late final initalValue;
  late final Map map;

  CustomTextFormField(
      {required ValueKey this.key,
      TextInputType? this.inputType,
      required String? this.initalValue,
      required Map this.map});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  _convertInput(String key) {
    switch (key) {
      case "location":
        return "\u{1F6B6} 위치 :";
      case "job":
        return "\u{1F4BC} 직업 :";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        key: widget.key,
        initialValue: widget.initalValue,
        textAlignVertical: TextAlignVertical(y: -0.5),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) return "필수";
          if (widget.inputType != null) {
            if (int.parse(value) > 210 || int.parse(value) < 145)
              return "145이상 210이하 입력";
          }
          return null;
        },
        onSaved: (newValue) {
          if (widget.inputType == null)
            widget.map["${widget.key.value}"] = newValue;
          else
            widget.map["${widget.key.value}"] = int.parse(newValue!);
        },
        keyboardType: widget.inputType ?? TextInputType.text,
        decoration: InputDecoration(
          isCollapsed: true,
          prefixIcon: Text(
            "${_convertInput(widget.key.value)}",
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class Bio extends StatefulWidget {
  Bio(
      {required ValueKey key,
      required String this.title,
      required String? this.initalValue,
      required Map this.map});

  late final String title;
  late final String? initalValue;
  late final Map map;

  @override
  State<Bio> createState() => _BioState();
}

class _BioState extends State<Bio> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height / 5,
            minWidth: MediaQuery.of(context).size.width,
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
          child: TextFormField(
            key: widget.key,
            maxLength: 1000,
            onSaved: (newValue) {
              (widget.map.putIfAbsent("bio", () => {}) as Map)[widget.title] =
                  newValue;
            },
            validator: (value) {
              // TODO : set Validators
              if (value.toString().trim().length < 10) return "50자 이상 필수";
              return null;
            },
            initialValue: widget.initalValue,
            maxLines: null,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none),
          ),
        ),
      ),
      Positioned(
        left: 25,
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text("${widget.title}"),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1)],
          ),
        ),
      )
    ]);
  }
}
