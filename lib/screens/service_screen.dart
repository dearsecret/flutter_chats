import 'package:chats/apis/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<UserProvider>();
    var photos = provider.photos;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: photos.length,
        itemBuilder: ((context, index) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(photos[index]))),
          );
        }));
  }
}
