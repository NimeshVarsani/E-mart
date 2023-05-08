import 'dart:collection';

import 'package:emart/main.dart';
import 'package:emart/screens/navigations_screens/account/account.dart';
import 'package:emart/screens/navigations_screens/cart/cart.dart';
import 'package:emart/screens/navigations_screens/categories.dart';
import 'package:emart/screens/navigations_screens/home/home.dart';
import 'package:emart/screens/navigations_screens/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// BuildContext? ctxHS;
var ctxProgressHS;

var bottomWidgetKey = GlobalKey<State<BottomNavigationBar>>();

class MyHomeScreen extends StatelessWidget {
  MyHomeScreen({Key? key}) : super(key: key);

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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'home screen',
            home: ProgressHUD(
              backgroundColor: Colors.white,
              indicatorColor: ColorAll.colorsPrimary,
              textStyle: TextStyle(
                color: ColorAll.colorsPrimary,
                fontSize: 18.sp,
              ),
              child: Builder(
                builder: (ctxProg) => HomeScreen(ctxProg),
              ),
            ),
          );
        });
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen(BuildContext ctxProg, {Key? key}) : super(key: key) {
    ctxProgressHS = ctxProg;
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String userId = "";

  void onItemTapped(int index) {
    if (_navigationQueue.isEmpty) {
      _navigationQueue.addLast(0);
    }
    if (index != _selectedIndex) {
      _navigationQueue.addLast(index);
      print('last element when added in navQ' + index.toString());
      setState(() {
        _selectedIndex = index;
      });
    }
    print('nav list' + _navigationQueue.toString());
  }

  static final _children = [
    MyHome(),
    Categories(),
    Notifications(),
    Cart(),
    MyAccount(),
  ];

  @override
  initState() {
    super.initState();
    _navigationQueue.add(0);

    userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  }

  ListQueue<int> _navigationQueue = ListQueue();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showAlertDialog,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: Text('E-Mart'),
        //   backgroundColor: ColorAll.colorsPrimary,
        // ),
        bottomNavigationBar: BottomNavigationBar(
          key: bottomWidgetKey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/home_outlined.png'),
                color: Colors.black,
                size: 22,
              ),
              label: 'Home',
              activeIcon: ImageIcon(AssetImage('assets/icons/home_filled.png'),
                  color: ColorAll.colorsPrimary, size: 22),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/categories_outline.png'),
                  color: Colors.black, size: 24),
              label: 'Categories',
              activeIcon: ImageIcon(
                  AssetImage('assets/icons/categories_fill.png'),
                  color: ColorAll.colorsPrimary,
                  size: 26),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/bell_outline.png'),
                  color: Colors.black, size: 22),
              label: 'Notify',
              activeIcon: ImageIcon(AssetImage('assets/icons/bell_fill.png'),
                  color: ColorAll.colorsPrimary, size: 22),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/trolley_outlined.png'),
                  color: Colors.black, size: 28),
              label: 'Cart',
              activeIcon: ImageIcon(
                  AssetImage('assets/icons/trolley_filled.png'),
                  color: ColorAll.colorsPrimary,
                  size: 28),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/user_outlined.png'),
                  color: Colors.black),
              // icon: Icon(Icons.account_circle_outlined, color: Colors.black),
              label: 'Account',
              activeIcon: ImageIcon(
                AssetImage('assets/icons/user_filled.png'),
                color: ColorAll.colorsPrimary,
              ),
            ),
          ],
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          iconSize: 28.0,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black87,
          onTap: onItemTapped,
        ),
        body: _children[_selectedIndex],
      ),
    );
  }

  Future<bool> _showAlertDialog() async {
    bool? shouldPop;
    if (_navigationQueue.isEmpty ||
        _navigationQueue.length == 1 && _navigationQueue.contains(0)) {
      shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure you want to Exit?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
      return shouldPop!;
    }

    setState(() {
      _navigationQueue.removeLast();
      _selectedIndex = _navigationQueue.last;
      print('selIndex' + _selectedIndex.toString());
      shouldPop == false;
    });

    print('nav list' + _navigationQueue.toString());

    return shouldPop!;
  }
}
