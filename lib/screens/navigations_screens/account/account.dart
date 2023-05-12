import 'dart:async';

import 'package:emart/auth_service.dart';
import 'package:emart/screens/navigations_screens/account/address.dart';
import 'package:emart/screens/navigations_screens/account/orders.dart';
import 'package:emart/main.dart';
import 'package:emart/screens/login_screen.dart';
import 'package:emart/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// BuildContext? ctxAS;
var ctxProgressAS;

class MyAccount extends StatelessWidget {
  MyAccount({Key? key}) : super(key: key);

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
              builder: (ctxProg) => Account(ctxProg),
            ),
          );
        });
  }
}

class Account extends StatefulWidget {
  Account(BuildContext ctxProg, {Key? key}) : super(key: key) {
    ctxProgressAS = ctxProg;
  }

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  var progress;

  String email = "";
  String name = "";
  String role = "";

  getUserData(String uid) async {
    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressAS);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/$uid').get();
      final data = Map<String, dynamic>.from(
        snapshot.value as Map,
      );
      print("getet=-=" + snapshot.value.toString());
      setState(() {
        if (snapshot.exists) {
          email = data['email'];
          print(data['email']);
          name = data['name'];
          role = data['role'];
          print(data['role']);
          // _isLoading = false;
        } else {
          print('No data available.');
          // _isLoading = false;
        }
      });
      Timer(const Duration(milliseconds: 20), () {
        progress.dismiss();
      });
    } catch (e) {
      return 'Error fetching user';
    }
  }

  @override
  void initState() {
    super.initState();

    getUserData((FirebaseAuth.instance.currentUser?.uid ?? ""));
    print((FirebaseAuth.instance.currentUser?.uid ?? ""));
    print((FirebaseAuth.instance.currentUser?.email ?? ""));
    print((FirebaseAuth.instance.currentUser?.displayName ?? ""));
  }

  signOut(BuildContext context) {
    AuthService().signOut();

    try {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyLoginPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      print(e);
    }
  }

  showLogoutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            title: _headerWidget(),
            actions: [
              _yesButtonWidget(context),
              _cancelButtonWidget(context),
            ],
            /*child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerWidget(),
                  const SizedBox(height: 20),
                  _yesButtonWidget(),
                  _cancelButtonWidget(context),
                ],
              ),
            ),*/
          );
        });
  }

  Text _headerWidget() {
    return const Text(
      "You sure you want to log out?",
      style: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
      textAlign: TextAlign.center,
    );
  }

  SizedBox _yesButtonWidget(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          signOut(context);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          shape: const StadiumBorder(),
        ),
        child: const Text(
          "Yes I'm sure",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Container _cancelButtonWidget(BuildContext context) {
    return Container(
      // width: double.maxFinite,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10),
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
        ),
        child: const Text(
          "Cancel",
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 28, bottom: 20),
        padding: EdgeInsets.only(bottom: 10),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      AppBar(
                        title: Text('Account'),
                        backgroundColor: ColorAll.colorsPrimary,
                      ),
                      Container(
                        color: Colors.blueGrey[50],
                        child: Stack(
                          children: [
                            Visibility(
                              visible: (role == 'admin'),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.only(
                                    right: 8,
                                    top: 8,
                                  ),
                                  child: Text(
                                    'Admin',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 50.0,
                                    foregroundImage: AssetImage(
                                      'assets/icons/profile-user.png',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (name.isNotEmpty)
                                          ? Text(name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16))
                                          : Text('User Name'),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      (email.isNotEmpty)
                                          ? Text(email)
                                          : Text('User Email'),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Util().makeCardWithTap(context, 'Orders', () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => Orders_screen()));
                      }),
                      Util().makeCard('Customer Care'),
                      Util().makeCard('Invite Friends & Earn'),
                      Util().makeCard('Game Zone'),
                      SizedBox(
                        height: 8,
                      ),
                      Util().makeCard('Wallet'),
                      Util().makeCard('Saved Cards'),
                      Util().makeCard('My Rewards'),
                      Util().makeCardWithTap(context, 'Address', () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => AddressScreen(context)));
                      }),
                      Util().makeCard('Wishlist'),
                      SizedBox(
                        height: 8,
                      ),
                      Util().makeCard('How To Return'),
                      Util().makeCard('Terms & Conditions'),
                      Util().makeCard('Returns & Refunds Policy'),
                      Util().makeCard('We Respect Your Privacy'),
                      Util().makeCard('Fees & Payments'),
                      Util().makeCard('Who We Are'),
                      Util().makeCard('Join Our Team'),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              showLogoutDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              backgroundColor: Colors.white,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  );
                },
                childCount: 1,
              ), //SliverChildB,
            ),
          ],
        ),
      ),
    );
  }
}
