import 'dart:collection';

import 'package:emart/main.dart';
import 'package:emart/screens/navigations_screens/account/account.dart';
import 'package:emart/screens/navigations_screens/cart/cart.dart';
import 'package:emart/screens/navigations_screens/categories.dart';
import 'package:emart/screens/navigations_screens/home/home.dart';
import 'package:emart/screens/navigations_screens/notifications.dart';
import 'package:emart/utils/app_icons.dart';
import 'package:emart/utils/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// var bottomWidgetKey = GlobalKey<State<BottomNavigationBar>>();

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
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
    const MyHome(),
    const Categories(),
    const Notifications(),
    const Cart(),
    const MyAccount(),
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
          // key: bottomWidgetKey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: UiUtils.getAssetImage(AppIcons.home_outlined, height: 30, width: 30, color: Colors.black),
              label: 'Home',
              activeIcon: UiUtils.getAssetImage(AppIcons.home_filled, height: 30, width: 30, color: ColorAll.colorsPrimary),
            ),
            BottomNavigationBarItem(
              icon: UiUtils.getAssetImage(AppIcons.categories_outline, height: 30, width: 30, color: Colors.black),
              label: 'Categories',
              activeIcon: UiUtils.getAssetImage(AppIcons.categories_fill, height: 30, width: 30, color: ColorAll.colorsPrimary),
            ),
            BottomNavigationBarItem(
              icon: UiUtils.getAssetImage(AppIcons.bell_outline, height: 30, width: 30, color: Colors.black),
              label: 'Notify',
              activeIcon: UiUtils.getAssetImage(AppIcons.bell_fill, height: 30, width: 30, color: ColorAll.colorsPrimary),
            ),
            BottomNavigationBarItem(
              icon: UiUtils.getAssetImage(AppIcons.trolley_outlined, height: 30, width: 30, color: Colors.black),
              label: 'Cart',
              activeIcon: UiUtils.getAssetImage(AppIcons.trolley_filled, height: 30, width: 30, color: ColorAll.colorsPrimary),
            ),
            BottomNavigationBarItem(
              icon: UiUtils.getAssetImage(AppIcons.user_outlined, height: 30, width: 30, color: Colors.black),
              // icon: Icon(Icons.account_circle_outlined, color: Colors.black),
              label: 'Account',
              activeIcon: UiUtils.getAssetImage(AppIcons.user_filled, height: 30, width: 30, color: ColorAll.colorsPrimary),
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
