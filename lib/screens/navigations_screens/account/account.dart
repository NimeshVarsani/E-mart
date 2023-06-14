import 'package:emart/auth_service.dart';
import 'package:emart/screens/navigations_screens/account/address.dart';
import 'package:emart/screens/navigations_screens/account/orders.dart';
import 'package:emart/main.dart';
import 'package:emart/screens/login_screen.dart';
import 'package:emart/utils/app_icons.dart';
import 'package:emart/utils/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> with TickerProviderStateMixin {
  String email = "";
  String name = "";
  String role = "";

  getUserData(String uid) async {
    context.loaderOverlay.show();

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
      context.loaderOverlay.hide();
    } catch (e) {
      return 'Error fetching user';
    }

    // context.loaderOverlay.hide();
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

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MyLoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: CustomScrollView(
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
                                padding: const EdgeInsets.only(
                                  right: 8,
                                  top: 8,
                                ),
                                child: const Text(
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
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 50.0,
                                  // foregroundImage: UiUtils.getAssetImage(AppIcons.profile_user),
                                  child: Container(
                                      child: UiUtils.getAssetImage(
                                          AppIcons.profile_user)),
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
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))
                                        : const Text('User Name'),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    (email.isNotEmpty)
                                        ? Text(email)
                                        : const Text('User Email'),
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
                    UiUtils().makeCardWithTap(context, 'Orders', () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => Orders_screen()));
                    }),
                    UiUtils().makeCard('Customer Care'),
                    UiUtils().makeCard('Invite Friends & Earn'),
                    UiUtils().makeCard('Game Zone'),
                    const SizedBox(
                      height: 8,
                    ),
                    UiUtils().makeCard('Wallet'),
                    UiUtils().makeCard('Saved Cards'),
                    UiUtils().makeCard('My Rewards'),
                    UiUtils().makeCardWithTap(context, 'Address', () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => AddressScreen(context)));
                    }),
                    UiUtils().makeCard('Wishlist'),
                    const SizedBox(
                      height: 8,
                    ),
                    UiUtils().makeCard('How To Return'),
                    UiUtils().makeCard('Terms & Conditions'),
                    UiUtils().makeCard('Returns & Refunds Policy'),
                    UiUtils().makeCard('We Respect Your Privacy'),
                    UiUtils().makeCard('Fees & Payments'),
                    UiUtils().makeCard('Who We Are'),
                    UiUtils().makeCard('Join Our Team'),
                    const SizedBox(
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
                            UiUtils.showCustomDialog(
                                context: context,
                                title: "You sure you want to log out?",
                                yesButtonText: "Yes I'm sure",
                                cancelButtonText: "Cancel",
                                signOut: () {
                                  signOut(context);
                                });
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
                    const SizedBox(
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
    );
  }
}
