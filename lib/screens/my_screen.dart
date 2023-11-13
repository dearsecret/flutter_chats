import 'dart:convert';

import 'package:chats/screens/party_detail.dart';
import 'package:chats/utils/alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/widget_party_card.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  List data = [];
  getMine() async {
    final token = await storage.read(key: "token");
    http.Response response = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/v1/meetings/me"),
      headers: {"Authorization": token!, "Content-Type": "Application/json"},
    );
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(utf8.decode(response.bodyBytes));
      });
    }
    print(data);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getMine();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.transparent,
                  title: Text("내가 쓴글"),
                )
              ];
            },
            body: Column(
              children: [
                if (data.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1.618,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                          ),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final image = ExtendedImage.network(
                              data[index]["photo"],
                            );
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return PartyDetail(
                                        index: index,
                                        pk: data[index]["pk"],
                                        image: image,
                                        gender: data[index]["user"]["gender"],
                                        title: data[index]["title"],
                                        date: data[index]["created"]);
                                  },
                                ));
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                child: PartyCard(
                                  data: data[index],
                                  image: image,
                                  index: index,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}
