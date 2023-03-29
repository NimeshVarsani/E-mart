import 'package:flutter/material.dart';

class OffersInList extends StatefulWidget {
  const OffersInList({Key? key}) : super(key: key);

  @override
  _OffersInListState createState() => _OffersInListState();
}

class _OffersInListState extends State<OffersInList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Image.asset(
                  "assets/images/hair_dryer.png"),
            ),
            Expanded(
              child: Image.asset(
                  "assets/images/laptop.png"),
            )
          ],
        ),
      ),
    );
  }
}