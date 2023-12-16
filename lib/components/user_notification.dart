import 'package:flutter/material.dart';

overlayTransform(BuildContext context, String text) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry? _overlay;
  _overlay = OverlayEntry(
    builder: (context) => UserNotification(
      notification: "$text",
      entry: _overlay,
    ),
  );
  overlayState.insert(_overlay);
  // Future.delayed(Duration(seconds: 5), () =>  _overlay?.remove());
}

class UserNotification extends StatefulWidget {
  late final String notification;
  late final OverlayEntry? entry;
  UserNotification(
      {super.key, required this.notification, required this.entry});

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    position = Tween<Offset>(begin: Offset(0, -2), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Alignment alignmment = Alignment.topCenter;
  // final height = MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          controller.reverse().then((_) => widget.entry?.remove());
        }
      },
      child: SafeArea(
          child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SlideTransition(
            position: position,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(1, 1))
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text("${widget.notification}")),
                    InkWell(
                      child: Icon(Icons.clear),
                      onTap: () {
                        widget.entry?.remove();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          // child: SlideTransition(
          //   position: position,
          //   child: Material(
          //     color: Colors.transparent,
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //       decoration: ShapeDecoration(
          //         color: Colors.white,
          //         shadows: [
          //           BoxShadow(
          //               color: Colors.grey,
          //               spreadRadius: 3,
          //               blurRadius: 3,
          //               offset: Offset(1, 1))
          //         ],
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(15)),
          //       ),
          //       child: Row(
          //         children: [
          //           Expanded(child: Text("${widget.notification}")),
          //           InkWell(
          //             child: Icon(Icons.clear),
          //             onTap: () {
          //               controller.reverse().then((_) => widget.entry?.remove());
          //             },
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
      )),
    );
  }
}
