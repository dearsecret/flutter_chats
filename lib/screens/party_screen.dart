import 'package:flutter/material.dart';

class Party extends StatefulWidget {
  const Party({super.key});

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text("helloasdxasdasdadasdsa")),
            Container(
              child: Row(
                children: [
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    splashColor: Colors.grey,
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    splashColor: Colors.grey,
                    onTap: () {},
                    child: Icon(
                      Icons.star_border,
                      size: 30,
                    ),
                  ),
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    splashColor: Colors.grey,
                    onTap: () {},
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                    ),
                  ),
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    splashColor: Colors.grey,
                    onTap: () {},
                    child: Icon(
                      Icons.notifications_none,
                      size: 30,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
