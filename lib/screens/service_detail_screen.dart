import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ServiceDetail extends StatelessWidget {
  late final String pk, name, image;
  ServiceDetail(
      {super.key,
      required String this.pk,
      required String this.name,
      required String this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Text("$name"),
                TextFormField(),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExtendedImage.network(
                    image,
                  ).image)),
                ),
                // SizedBox(
                //   height: 100,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// CustomScrollView(
//             slivers: [
//               SliverFillRemaining(
//                 hasScrollBody: false,
//                 child: Column(
//                   children: [
//                     Text("$name"),
//                     Expanded(
//                         child: ExtendedImage.network(
//                       image,
//                       fit: BoxFit.cover,
//                     )),
//                     Text("$name"),
//                   ],
//                 ),
//               ),
//             ],
//           )
// AspectRatio(
//               aspectRatio: 1 / 1,
//               child: Expanded(
//                 child: ExtendedImage.network(
//                   image,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Text("$pk"),
//             Text("$name"),
