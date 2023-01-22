import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  var name = [
    "assets/applinces.png",
    "assets/beauty.png",
    "assets/electronic.png",
    "assets/fashion.png",
    "assets/grocery.png",
    "assets/mobiles.png",
    "assets/sports_and_more.png",
    "assets/toys_and_babby.png",
    "assets/home.png"
  ];

  buildItem(BuildContext context, int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 6,
      height: MediaQuery.of(context).size.height / 11,
      child: Image.asset(
        name[index],
        height: MediaQuery.of(context).size.height / 11,
        width: MediaQuery.of(context).size.width / 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 11,
      child: ListView.builder(
        itemCount: 8,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return buildItem(context, index);
        },
      ),
    );
  }
}