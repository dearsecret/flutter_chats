import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 테스트용 Login Valdiator 주석처리 설정
class LogOut extends StatefulWidget {
  const LogOut({super.key});

  @override
  State<LogOut> createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  static final storage = new FlutterSecureStorage();

  final _formkey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userPassword = '';
  String _userNumber = '';

  bool _isEnabled = true;

  void _toggleEnabled() {
    setState(() {
      _isEnabled = !_isEnabled;
    });
  }

  void _tryValidation() {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      _formkey.currentState!.save();
    }
  }

  _requestLogin(username, password) async {
    Map data = {
      "username": username,
      "password": password,
    };
    var body = jsonEncode(data);
    String url = "http://127.0.0.1:8000/api/v1/users/jwt-login";
    try {
      var res = await http.post(Uri.parse(url),
          body: body, headers: {"content-type": "application/json"});
      final token = jsonDecode(res.body)["token"];
      final fire_token = jsonDecode(res.body)["fire_token"];
      if (res.statusCode == 200) {
        print(token);
        print(fire_token);
        try {
          final userCredential =
              await FirebaseAuth.instance.signInWithCustomToken(fire_token);
          print("Sign-in successful.");
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case "invalid-custom-token":
              print("The supplied token is not a Firebase custom auth token.");
              break;
            case "custom-token-mismatch":
              print("The supplied token is for a different Firebase project.");
              break;
            default:
              print("Unkown error.");
          }
        }
        await storage.write(key: "token", value: token);
        // .then((value) => Navigator.of(context).pushNamed("/main"));
        print(token);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("잠시 후 다시 시도해주세요.")));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("잠시 후 다시 시도해주세요.")));
    }
  }

  bool _isLoggin = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Stack(children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "금지팡이",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[300],
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RichText(
                    text: TextSpan(
                        text: _isLoggin ? "로그인" : "회원가입",
                        style: const TextStyle(
                            color: Colors.brown, fontWeight: FontWeight.bold),
                        children: const [
                          TextSpan(
                              text: " 후 대화에 참여하세요.",
                              style: TextStyle(color: Colors.black))
                        ]),
                  )
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(top: 9),
                  decoration: BoxDecoration(
                      color: Colors.brown[50],
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey, spreadRadius: 5, blurRadius: 10)
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLoggin = true;
                              });
                            },
                            child: Text(
                              "로그인",
                              style: _isLoggin
                                  ? TextStyle(
                                      color: Colors.brown[400],
                                      fontWeight: FontWeight.bold)
                                  : const TextStyle(color: Colors.grey),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLoggin = false;
                                _isEnabled = true;
                              });
                            },
                            child: Text(
                              "회원가입",
                              style: !_isLoggin
                                  ? TextStyle(
                                      color: Colors.brown[400],
                                      fontWeight: FontWeight.bold)
                                  : const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      if (_isLoggin)
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: const ValueKey(1),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    // if (!RegExp(
                                    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    //     .hasMatch(value!)) {
                                    //   return "이메일 주소를 확인해주세요.";
                                    // }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    setState(() {
                                      _userEmail = newValue!;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _userEmail = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "이메일",
                                    prefixIcon: Icon(
                                      Icons.mail,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  key: const ValueKey(2),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    // if (!RegExp(
                                    //         r"(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})")
                                    //     .hasMatch(value!)) {
                                    //   return "비밀번호는 대문자, 소문자, 특수문자, 숫자를 혼합한 8자리 이상 요구됩니다.";
                                    // }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    setState(() {
                                      _userPassword = newValue!;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _userPassword = value;
                                    });
                                  },
                                  obscureText: true,
                                  focusNode: FocusNode(),
                                  decoration: const InputDecoration(
                                    hintText: "비밀번호",
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 50,
                                    width: 50,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 10,
                                              offset: Offset(1, 1))
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(25)),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.brown,
                                            Colors.brown.shade100
                                          ],
                                        ),
                                      ),
                                      child: IconButton(
                                          icon: const Icon(Icons.login),
                                          onPressed: () {
                                            _tryValidation();
                                            _requestLogin(
                                                _userEmail, _userPassword);
                                          }),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      if (!_isLoggin)
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            // key: _formkey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  key: const ValueKey(3),
                                  validator: (value) {
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value!)) {
                                      return "이메일 주소를 확인해주세요.";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    setState(() {
                                      _userEmail = newValue!;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _userEmail = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "이메일",
                                    prefixIcon: Icon(
                                      Icons.mail,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  key: const ValueKey(4),
                                  validator: (value) {
                                    if (!RegExp(
                                            r"(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})")
                                        .hasMatch(value!)) {
                                      return "비밀번호는 대문자, 소문자, 특수문자, 숫자를 혼합한 8자리 이상 요구됩니다.";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    setState(() {
                                      _userPassword = newValue!;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _userPassword = value;
                                    });
                                  },
                                  obscureText: true,

                                  // focusNode: FocusNode(),
                                  decoration: const InputDecoration(
                                    hintText: "비밀번호",
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: _isEnabled,
                                      child: Expanded(
                                        child: TextFormField(
                                          key: const ValueKey(5),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          maxLength: 11,
                                          validator: (value) {
                                            if (!RegExp(
                                                    r"^01(0|1|6|7|8|9|)\d{7,8}$")
                                                .hasMatch(value!)) {
                                              return "전회번호를 확인해주세요.";
                                            }
                                            return null;
                                          },
                                          onSaved: (newValue) {
                                            setState(() {
                                              _userNumber = newValue!;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _userNumber = value;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            counterText: "",
                                            hintText: "전화번호",
                                            fillColor: Colors.white,
                                            filled: true,
                                            prefixIcon: Icon(
                                              Icons.phone_rounded,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !_isEnabled,
                                      child: Expanded(
                                        child: TextFormField(
                                          key: const ValueKey(5),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          maxLength: 11,
                                          validator: (value) {
                                            if (RegExp(r"^\d{8}$")
                                                .hasMatch(value!)) {}
                                            return "인증번호를 확인해주세요.";
                                          },
                                          onSaved: (newValue) {
                                            setState(() {
                                              _userNumber = newValue!;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _userNumber = value;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            counterText: "",
                                            hintText: "인증번호",
                                            fillColor: Colors.white,
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    if (_isEnabled)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 8, right: 15),
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            child: const Text("인증문자")),
                                      ),
                                    if (!_isEnabled)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 8, right: 15),
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            child: const Text("번호인증")),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
