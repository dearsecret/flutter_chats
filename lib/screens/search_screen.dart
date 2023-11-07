import 'dart:convert';

import 'package:chats/components/widget_party_card.dart';
import 'package:chats/screens/party_detail.dart';
import 'package:chats/utils/alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String title = "";
  List data = [];
  search(String title) async {
    final token = await storage.read(key: "token");
    http.Response response = await http.get(
        Uri.parse(
            "http://127.0.0.1:8000/api/v1/meetings/search?title=" + "$title"),
        headers: {"Authorization": token!});
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(utf8.decode(response.bodyBytes));
      });
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.transparent,
                  title: Text("검색하기"),
                )
              ];
            },
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "2글자 이상 입력하세요.",
                          suffixIcon: IconButton(
                              onPressed: () {
                                search(title);
                              },
                              icon: Icon(Icons.search)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 1))),
                      onChanged: (value) {
                        title = value;
                      },
                    )),
                  ]),
                  if (data.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1 / 1.618,
                          crossAxisCount: 3,
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
                    )
                ],
              ),
            )),
      ),
    );
  }
}
