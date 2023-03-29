import 'dart:async';
import 'dart:convert';

import 'package:emart/main.dart';
import 'package:emart/screens/home_screen.dart';
import 'package:emart/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

var ctxProgressCS;

class Cart extends StatelessWidget {
  Cart({Key? key}) : super(key: key);

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
                builder: (ctxProg) => MyCart(ctxProg),
              ),
            );
        });
  }
}

class MyCart extends StatefulWidget {
  MyCart(BuildContext ctxProg, {Key? key}) : super(key: key) {
    ctxProgressCS = ctxProg;
  }

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  var progress;
  bool isCartEmpty = false;

  int _quantity = 0;

  final _dbRef = FirebaseDatabase.instance
      .ref()
      .child('users/${FirebaseAuth.instance.currentUser!.uid}/cart/products');

  @override
  void initState() {
    super.initState();

    // Timer(const Duration(milliseconds: 10), () {
      progress = ProgressHUD.of(ctxProgressCS);

      Timer(const Duration(seconds: 5), () {
        progress.dismiss();
      });
    // });
  }

  _showCartDelDialog(String pId) async {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure you want to Remove Item?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _dbRef.child(pId).remove();
                  Util.showToast('Product Removed');

                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 28),
        child: Column(
          children: [
            AppBar(
              title: Text('Cart'),
              backgroundColor: ColorAll.colorsPrimary,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  padding: EdgeInsets.only(top: 5,bottom: 33, left: 4, right: 4),
                  query: _dbRef,
                  itemBuilder: (context, snapshot, animation, index) {
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100.0,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.child('thumbnail').value.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.child('title').value.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '\$${snapshot.child('price').value.toString()}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    /*Row(
                                    children: [
                                      IconButton(
                                        onPressed: _quantity > 1
                                            ? () => setState(() => _quantity = _quantity-1)
                                            : null,
                                        icon: Icon(Icons.remove_circle_outline),
                                      ),
                                      Text(
                                        '$_quantity',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => setState(() => _quantity = _quantity + 1),
                                        icon: Icon(Icons.add_circle_outline),
                                      ),
                                    ],
                                  ),*/
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: (){
                                    _showCartDelDialog(snapshot.child('productId').value.toString());
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    /*Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/cart.png',
                            height: 150,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          const Text(
                            'Your cart is empty!',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                MaterialStateProperty.all(const Color(0xff2874F0)),
                              ),
                              onPressed: () {
                                BottomNavigationBar navigationBar = bottomWidgetKey
                                    .currentWidget as BottomNavigationBar;
                                navigationBar.onTap!(0);
                              },
                              child: const Text(
                                'Shop now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );*/
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
