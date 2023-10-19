import 'package:chats/providers/user_profile_provider.dart';
import 'package:chats/screens/upload_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  Future _refresh() async {}
  @override
  Widget build(BuildContext context) {
    final images = context
        .select<UserProfileProvider, List>((provider) => provider.images);
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text("\u{1F4B0} 재산 인증"),
                    Text("\u{1F4AC} 자기소개"),
                    Text("\u{1F646} 선호"),
                    Text("\u{1F645} 거부"),
                    Text("\u{1F491} 연애"),
                    Text("취미"),
                    Text("성격"),
                    Text("MBTI"),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UploadImage()));
                        },
                        child: Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "프로필 사진",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    ...images.map((e) {
                                      return Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            child: e != null
                                                ? null
                                                : Icon(Icons.add),
                                            margin: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 3,
                                                  color: Colors.brown.shade200),
                                              image: e != null
                                                  ? DecorationImage(
                                                      image:
                                                          ExtendedImage.network(
                                                        e,
                                                        cache: true,
                                                      ).image,
                                                      fit: BoxFit.cover)
                                                  : null,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ]),
                        )),
                    Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\u{1F464} 기본 정보",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.4,
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                childAspectRatio: 2 / 1,
                                crossAxisCount: 3,
                                mainAxisSpacing: 1,
                                children: [
                                  Text("\u{1F4CD} 지역"),
                                  Text("\u{1F393} 학력"),
                                  Text("\u{1F6B6} 키"),
                                  Text("\u{1F4AA} 체형"),
                                  Text("\u{1F64F} 종교"),
                                  Text("\u{1F4BC} 직업"),
                                  Text("\u{1F3AD} 정치"),
                                  Text("\u{1F6AC} 흡연"),
                                  Text("\u{1F377} 음주"),
                                  Text("\u{1F698} 차량"),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
