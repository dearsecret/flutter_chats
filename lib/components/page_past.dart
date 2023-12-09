import 'package:chats/components/widget_choice_history.dart';
import 'package:chats/providers/daily_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Past extends StatefulWidget {
  const Past({super.key});

  @override
  State<Past> createState() => _PastState();
}

class _PastState extends State<Past> {
  @override
  void initState() {
    context.read<DailyProvider>().setHistory;
    super.initState();
  }

  Future _refresh() async {
    context.read<DailyProvider>().setHistory;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            print("please Make Function for ScrollListener");
          }
          return false;
        },
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                itemCount: context.watch<DailyProvider>().getHistoryLength,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 1.618,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 25),
                itemBuilder: (context, index) {
                  return ChoiceHistory(
                    key: ValueKey(index),
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
