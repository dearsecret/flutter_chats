import 'package:flutter/material.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  Future _refresh() async {}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          padding: EdgeInsets.all(10),
          child: GridView.count(
              mainAxisSpacing: 25,
              crossAxisSpacing: 15,
              childAspectRatio: 1 / 2,
              crossAxisCount: 2,
              children: List.generate(
                12,
                (index) => Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 150,
                      child: Container(
                        margin: EdgeInsets.all(12),
                        child: Container(
                            // child: ,
                            ),
                        decoration: BoxDecoration(
                          color: Colors.brown[400],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1, 1),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(spreadRadius: 1, blurRadius: 3)
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
