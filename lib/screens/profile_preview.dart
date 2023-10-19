import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_profile_provider.dart';

class ProfilePreview extends StatefulWidget {
  const ProfilePreview({super.key});

  @override
  State<ProfilePreview> createState() => _ProfilePreviewState();
}

class _ProfilePreviewState extends State<ProfilePreview> {
  Future _refresh() async {}
  @override
  Widget build(BuildContext context) {
    final images = context
        .select<UserProfileProvider, List>((provider) => provider.images);
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(children: [
            for (var image in images)
              image != null
                  ? AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ExtendedImage.network(
                        image,
                        cache: true,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      child: null,
                    )
          ]),
        ),
      ),
    );
  }
}
