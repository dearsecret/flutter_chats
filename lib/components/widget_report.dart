import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Container(
        height: 36,
        width: 48,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.more_vert,
        ),
      ),
      onSelected: (value) {},
      itemBuilder: (context) => [],
    );
  }
}
