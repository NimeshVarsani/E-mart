import 'package:flutter/material.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 5,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Image.asset(
                "assets/images/telivision.png"
            ),
          ),
          Expanded(
            child: Image.asset(
                "assets/images/running.png"
            ),
          ),
          Expanded(
            child: Image.asset(
                "assets/images/mobile_top.png"
            ),
          ),
        ],
      ),
    );
  }
}