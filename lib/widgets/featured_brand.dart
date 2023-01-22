import 'package:flutter/material.dart';

class FeaturedBrand extends StatefulWidget {
  const FeaturedBrand({Key? key}) : super(key: key);

  @override
  _FeaturedBrandState createState() => _FeaturedBrandState();
}

class _FeaturedBrandState extends State<FeaturedBrand> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.45,
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 20,bottom: 8,top: 8),
              child: Text(
                'Featured Brand',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20,bottom: 8),
              child: Text('Sponsored',style: TextStyle(color: Colors.grey),),
            ),
            Image.asset(
              "assets/power_bank.png",
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
    );
  }
}