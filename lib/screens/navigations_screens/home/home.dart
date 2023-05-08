import 'dart:convert';

import 'package:emart/main.dart';
import 'package:emart/models/products.dart';
import 'package:emart/screens/navigations_screens/home/product_details.dart';
import 'package:emart/widgets/noDataFound.dart';
import 'package:emart/widgets/shimmerLoadingContainer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var ctxProgressH;

class MyHome extends StatelessWidget {
  MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ProgressHUD(
            backgroundColor: Colors.white,
            indicatorColor: ColorAll.colorsPrimary,
            textStyle: TextStyle(
              color: ColorAll.colorsPrimary,
              fontSize: 18.sp,
            ),
            child: Builder(
              builder: (ctxProg) => Home(ctxProg),
            ),
          );
        });
  }
}

class Home extends StatefulWidget {
  Home(BuildContext ctxProg, {Key? key}) : super(key: key) {
    ctxProgressH = ctxProg;
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List productsList = [];
  List searchProductsList = [];
  var progress;

  TextEditingController searchController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.ref().child('new_products/products');

  @override
  void initState() {
    super.initState();
    getproductData();
  }

  getproductData() async {
    productsList.clear();
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('new_products/products');
    // FirebaseDatabase.instance.ref().child('products');

    databaseReference.once().then((snapshot) {
      setState(() {
        productsList = snapshot.snapshot.value as List;
        searchProductsList = snapshot.snapshot.value as List;
      });

      var jsonData = productsList[1]['category'];
      print('jsonDataList=-=>' + productsList.toString());
      print('jsonData=-=>' + jsonData.toString());
    });
  }

  searchDir(String cType) {
    print(cType + "<===--->");
    if (cType.trim().isNotEmpty) {
      // productsList.clear();
      productsList = [];
      searchProductsList.forEach((list) {
        setState(() {
          String brand = list['brand'];
          String categories = list['category'];
          String title = list['title'];
          if (brand.toLowerCase().contains(cType.trim().toLowerCase()) ||
              categories.toLowerCase().contains(cType.trim().toLowerCase()) ||
              title.toLowerCase().contains(cType.trim().toLowerCase())) {
            productsList.add(list);
          }
        });
        // dummyListData.add(CandidatesData());
      });
      print(cType + "%%%%%%%<===--->" + (productsList.length.toString()));
    } else {
      setState(() {
        print("length--->" + (productsList.length.toString()));
        productsList.clear();
        productsList.addAll(searchProductsList);
      });
    }
  }

  Widget buildProductsShimmer() {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.40,
                  decoration: BoxDecoration(
                      // color: context.color.secondaryColor,
                      // border:
                      //     Border.all(width: 1.5, color: context.color.borderColor),
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomShimmer(
                          width: 160,
                          height: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomShimmer(
                          width: 140,
                          height: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomShimmer(
                          width: 120,
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mainHeight = MediaQuery.of(context).size.height;
    var mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      /* appBar: AppBar(
        toolbarHeight: kToolbarHeight + 90.0,
        title: Text('E-Mart'),
        centerTitle: true,
        backgroundColor: ColorAll.colorsPrimary,
      ),*/
      body: (productsList.isNotEmpty)
          ? Container(
              child: SizedBox(
                height: mainHeight,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight + 90.0),
                      child: Container(),
                    ),
                    Container(
                      width: mainWidth,
                      height: 45,
                      margin: EdgeInsets.only(
                        top: 2.sp,
                        bottom: 8.sp,
                        left: 20,
                        right: 20,
                      ),
                      padding: EdgeInsets.only(
                        left: 8.sp,
                        // right: 8.sp,
                      ),
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.none,
                        controller: searchController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search by Product, Brand & more...',
                            prefixIcon: Icon(Icons.search)),
                        onChanged: (value) {
                          searchDir(value);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding:
                            EdgeInsets.only(bottom: 33, left: 10, right: 10),
                        itemCount: productsList.length,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetails(context, index),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //image
                                  Container(
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          productsList[index]['thumbnail']
                                              .toString(),
                                          // productsList[index]['category']['image']
                                          //     .toString(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          productsList[index]['brand']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          productsList[index]['title']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Text(
                                              '\$${productsList[index]['price'].toString()}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              '\$${productsList[index]['price'].toString()}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey.shade500,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '${productsList[index]['discountPercentage'].toString()}\% off',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          : buildProductsShimmer(),
    );
  }

/*@override
  Widget build(BuildContext context) {
    var mainHeight = MediaQuery.of(context).size.height;
    var mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 28),
        child: Column(
          children: [
            AppBar(
              title: Text('E-Mart'),
              backgroundColor: ColorAll.colorsPrimary,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Center(child: CircularProgressIndicator()),
                padding: EdgeInsets.only(bottom: 33, left: 10, right: 10),
                query: dbRef,
                itemBuilder: (context, snapshot, animation, index){
                  return InkWell(
                    onTap: (){
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(context, index),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 1.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //image
                          Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    snapshot.child('thumbnail').value.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${snapshot.child('brand').value.toString()}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  snapshot.child('title').value.toString(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      '\$${snapshot.child('price').value.toString()}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 6,),
                                    Text(
                                      '\$${snapshot.child('price').value.toString()}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey.shade500,
                                        decoration: TextDecoration. lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  '${snapshot.child('discountPercentage').value.toString()}\% off',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}
