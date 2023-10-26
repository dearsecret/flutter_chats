import 'package:flutter/material.dart';

class Party extends StatefulWidget {
  const Party({super.key});

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          primary: false,
          expandedHeight: 150.0,
          floating: true,
          pinned: false,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('Available seats'),
          ),
        ),
        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (context, index) {
        //       return;
        //     },
        //   ),
        // ),
        SliverList(
            delegate: SliverChildListDelegate([
          ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].map((e) => Container(
                height: 120,
                child: Text("$e"),
              ))
        ])),
      ],
    );
  }
}
