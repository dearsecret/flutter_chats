import 'package:chats/providers/init_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Alarm extends StatelessWidget {
  Alarm({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      child: Container(
        margin: EdgeInsets.all(3),
        child: Icon(Icons.notifications_none_outlined),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            List provider = context.watch<Init>().getRepository;
            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove,
                      color: Colors.grey,
                    ),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * .4),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("${provider[index]}"),
                      );
                    },
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
