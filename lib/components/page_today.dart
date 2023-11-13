import 'package:chats/components/widget_choice.dart';
import 'package:flutter/material.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  Future _refresh() async {}
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              itemCount: 8,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.618,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30),
              itemBuilder: (context, index) {
                return Choice(
                  key: ValueKey(index),
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
