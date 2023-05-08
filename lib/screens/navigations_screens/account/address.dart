import 'dart:async';

import 'package:emart/main.dart';
import 'package:emart/screens/navigations_screens/account/add_address.dart';
import 'package:emart/utils/utils.dart';
import 'package:emart/widgets/noDataFound.dart';
import 'package:emart/widgets/shimmerLoadingContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BuildContext? ctxA;
var ctxProgressA;

class AddressScreen extends StatelessWidget {
  AddressScreen(BuildContext ctxLS1, {Key? key}) : super(key: key) {
    ctxA = ctxLS1;
  }

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
              builder: (ctxProg) => MyAddressScreen(ctxProg),
            ),
          );
        });
  }
}

class MyAddressScreen extends StatefulWidget {
  MyAddressScreen(BuildContext ctxProg, {Key? key}) : super(key: key) {
    ctxProgressA = ctxProg;
  }

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  var progress;
  bool hasAddData = false;
  List addressList = [];
  String addressName = "";
  String streetAddress = "";
  String area = "";
  String city = "";
  String state = "";
  String country = "";
  String pincode = "";
  String mob_no = "";

  var dbRef = FirebaseDatabase.instance
      .ref()
      .child('users/${FirebaseAuth.instance.currentUser?.uid}/address');

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  _getAddress() async {
    addressList.clear();
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('users/${FirebaseAuth.instance.currentUser?.uid}/address');

    databaseReference.once().then((snapshot) {
      final data = Map<String, dynamic>.from(
        snapshot.snapshot.value as Map,
      );
      print('jsonData=-=>' + data.toString());
      print('jsonDatavalsss=-=>' + data.keys.toList().toString());

      // var list = data.values as List;
      setState(() {
        addressList = data.values.toList(growable: true);
      });
      print('list=-=>' + addressList.toString());
      print('list=-=>' + addressList[0]['area'].toString());
      setState(() {
        // addressList = snapshot.snapshot.value as List;
      });

      // var jsonData = addressList[0]['address_name'];
      // print('jsonaddressList=-=>' + addressList.toString());
      // print('jsonData=-=>' + jsonData.toString());
    });
  }

  /*getAddress() async {

    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressA);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    var userId = FirebaseAuth.instance.currentUser?.uid;
    var dbRef = FirebaseDatabase.instance.ref().child('users/$userId/address');
    DatabaseEvent event = await dbRef.once();
    print(event.snapshot.exists);

    if(event.snapshot.exists) {
      setState(() {
        hasAddData = true;
      });
      final data = Map<String, dynamic>.from(event.snapshot.value as Map,);
      print('data=-='+data.toString());

      addressName = data['address_name'];
      streetAddress = data['street_address'];
      area = data['area'];
      city = data['city'];
      state = data['state'];
      country = data['country'];
      pincode = data['pincode'];
      mob_no = data['mob_no'];

    }

    Timer(const Duration(milliseconds: 20), () {
      progress.dismiss();
    });

  }*/

  delAddress(String addressName) async {
    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressA);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    dbRef.child(addressName).remove();
    Util.showToast('Address Deleted');
    _getAddress();

    Timer(const Duration(milliseconds: 20), () {
      progress.dismiss();
    });
  }

  _showAddressDelDialog(String addressName) async {
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
                delAddress(addressName);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
  Widget buildAddressShimmer() {
    return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  // color: context.color.secondaryColor,
                  // border:
                  //     Border.all(width: 1.5, color: context.color.borderColor),
                ),
                child: CustomShimmer(
                  width: double.infinity,
                  height: 400,
                ),
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    var mainWidth = MediaQuery.of(context).size.width;
    var mainHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorAll.colorsPrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(ctxA!);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Addresses",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => AddAddressScreen(context, ""),
                ),
              )
                  .then((value) {
                setState(() {
                  if(value == true){
                    _getAddress();
                  }
                });
              });
            },
            child: Text(
              '+ Add address',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: (addressList.isNotEmpty) ? ListView.builder(
        itemCount: addressList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Card(
                margin: EdgeInsets.all(13),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (addressList[index]['default'].toString() ==
                                '1')
                              Container(
                                height: 20,
                                width: 65,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                ),
                                child: Center(
                                  child: Text(
                                    "DEFAULT",
                                    style: TextStyle(
                                        fontSize: 13.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(addressList[index]['address_name'].toString(),

                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(addressList[index]['street_address'].toString() +
                                ","),
                            Text(addressList[index]['area'].toString() +
                                ", " +
                                addressList[index]['city'].toString() +
                                ","),
                            // Text(city.toString() + ","),
                            Text(
                                addressList[index]['state'].toString() + ","),
                            Text(addressList[index]['country'].toString()),
                            Text(addressList[index]['pincode'].toString()),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Phone: " +
                                  addressList[index]['mob_no'].toString(),
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AddAddressScreen(
                                        context,
                                        addressList[index]['address_name'].toString()),
                                  ),
                                ).then((value) {
                                  if(value == true){
                                    _getAddress();
                                  }
                                });
                              },
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.blue),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: () {
                                // _showAddressDelDialog(snapshot
                                //     .child('address_name')
                                //     .value
                                //     .toString());
                                _showAddressDelDialog(
                                    addressList[index]['address_name'].toString());
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ) : buildAddressShimmer(),
    );
  }

/* @override
  Widget build(BuildContext context) {
    var mainWidth = MediaQuery.of(context).size.width;
    var mainHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorAll.colorsPrimary,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(ctxA!);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Addresses",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AddAddressScreen(context, ""),
                    ),
                  ).then((value) {
                    setState(() {
                      // if(value == true){
                      //   getAddress();
                      // }
                    });
                  });
                },
                child: Text('+ Add address', style: TextStyle(color: Colors.white),),)
          ],
        ),
        body:
        // (hasAddData) ?
        FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            return Column(
              children: [
                Card(
                  margin: EdgeInsets.all(13),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(snapshot.child('default').value.toString() == '1')
                              Container(
                                height: 20,
                                width: 65,
                                decoration:
                                BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Center(
                                  child: Text(
                                    "DEFAULT",
                                    style: TextStyle(
                                        fontSize :13.0, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.child('address_name').value.toString(),
                                style: TextStyle(
                                    fontSize :15.0, color: Colors.black),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(snapshot.child('street_address').value.toString() +
                                  ","),
                              Text(snapshot.child('area').value.toString() + ", " + snapshot.child('city').value.toString() + ","),
                              // Text(city.toString() + ","),
                              Text(snapshot.child('state').value.toString() + ","),
                              Text(snapshot.child('country').value.toString()),
                              Text(snapshot.child('pincode').value.toString()),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Phone: " + snapshot.child('mob_no').value.toString(),
                                style: TextStyle(
                                    fontSize :15.0, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddAddressScreen(context, snapshot.child('address_name').value.toString()),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.blue),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: () {
                                  _showAddressDelDialog(snapshot.child('address_name').value.toString());
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        )
            */ /*: Center(
            child: Container(
              child: Text('You have no address, Please your address.'),
            ),
        ),*/ /*
        );
  }*/
}
