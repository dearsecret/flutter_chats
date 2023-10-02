import 'package:flutter/material.dart';

class DefaultAppbar extends StatelessWidget {
  const DefaultAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      leading: Center(
          child: Text(
        "APPNAME",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      )),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'logout',
          onPressed: () {
            // logout();
          },
        )
      ],
    );
  }
}
