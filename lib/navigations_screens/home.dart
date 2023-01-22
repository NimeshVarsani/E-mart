import 'package:emart/widgets/categories_list.dart';
import 'package:emart/widgets/featured_brand.dart';
import 'package:emart/widgets/offers.dart';
import 'package:emart/widgets/offers_in_list.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('M-mart'),
        backgroundColor: const Color(0xff2874F0),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 11,
              color: const Color(0xff2874F0),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: InkWell(
                    child: Row(
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.search),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Search for Products, Brands and More',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const CategoriesList(),
            const OffersInList(),
            const Offers(),
            const FeaturedBrand(),

            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );

  }
}
