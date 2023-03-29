import 'package:emart/main.dart';
import 'package:emart/models/products.dart';
import 'package:emart/screens/navigations_screens/home/product_details.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// BuildContext? ctxH;
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
  List<Products> productsList = [];
  var progress;

  final dbRef = FirebaseDatabase.instance.ref().child('new_products/products');

  @override
  void initState() {
    super.initState();
  }

  /*Widget productsBuild(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 16.0),
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 0.0,
      childAspectRatio: MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height)*1.1,
      children: List.generate(
        productsList.length,
        (index) => GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) => ProductDetails(context, index)));
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
                          productsList[index].thumbnail.toString()),
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
                        '${productsList[index].brand}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        productsList[index].title.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8.0),


                      Row(
                        children: [
                          Text(
                            '\$${productsList[index].price}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 6,),
                          Text(
                            '\$${productsList[index].price! - 12}',
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
                        '${productsList[index].discountPercentage}\% off',
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
        ),
      ),
    );
  }*/

  @override
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
      )
      /*RefreshIndicator(
        displacement: 68.0,

        onRefresh: () async{
          getProductsData();
        },
        child: Container(
            margin: EdgeInsets.only(top: 60),
            padding: EdgeInsets.only(bottom: 40),
            child: productsBuild(context)
            // child: Container()
            ),
      ),*/
    );
  }
}
