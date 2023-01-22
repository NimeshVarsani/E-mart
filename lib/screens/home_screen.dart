import 'package:emart/navigations_screens/account.dart';
import 'package:emart/navigations_screens/cart.dart';
import 'package:emart/navigations_screens/categories.dart';
import 'package:emart/navigations_screens/home.dart';
import 'package:emart/navigations_screens/notifications.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final _children = [
    const Home(),
    const Categories(),
    const Notifications(),
    const Cart(),
    const Account(),
  ];

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,color: Colors.black,),
            label: 'Home',
            activeIcon: Icon(Icons.home_outlined, color: Colors.blue,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined, color: Colors.black),
            label: 'Categories',
            activeIcon: Icon(Icons.category_outlined, color: Colors.blue,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined, size: 25,color: Colors.black),
            label: 'Notify',
            activeIcon: Icon(Icons.notifications_none_outlined, size: 25,color: Colors.blue,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel, size: 25,color: Colors.black),
            label: 'Cart',
            activeIcon: Icon(Icons.card_travel, size: 25,color: Colors.blue,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, color: Colors.black),
            label: 'Account',
            activeIcon: Icon(Icons.account_circle_outlined, color: Colors.blue,),
          ),

        ],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 28.0,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        onTap: _onItemTapped,
      ),
      body: _children[_selectedIndex],
    );

  }
}

