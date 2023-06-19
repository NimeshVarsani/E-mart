import 'package:emart/main.dart';
import 'package:emart/screens/navigations_screens/account/add_address.dart';
import 'package:emart/utils/app_icons.dart';
import 'package:emart/utils/ui_utils.dart';
import 'package:emart/widgets/shimmerLoadingContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isLoading = true;
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
      if (snapshot.snapshot.exists) {
        final data = Map<String, dynamic>.from(
          snapshot.snapshot.value as Map,
        );
        print('jsonData=-=>$data');
        print('jsonDatavalsss=-=>${data.keys.toList()}');

        // var list = data.values as List;
        setState(() {
          addressList = data.values.toList(growable: true);
        });
        print('list=-=>$addressList');
        print('list=-=>${addressList[0]['area']}');
        setState(() {
          isLoading = false;
          // addressList = snapshot.snapshot.value as List;
        });
      } else {
        setState(() {
          isLoading = false;
          // addressList = snapshot.snapshot.value as List;
        });
      }
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
    context.loaderOverlay.show();

    dbRef.child(addressName).remove();
    UiUtils.showToast('Address Deleted');
    _getAddress();

    context.loaderOverlay.hide();
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
                decoration: const BoxDecoration(
                    // color: context.color.secondaryColor,
                    // border:
                    //     Border.all(width: 1.5, color: context.color.borderColor),
                    ),
                child: const CustomShimmer(
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
      backgroundColor: Colors.white,
      // backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorAll.colorsPrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
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
                  builder: (context) => AddAddressScreen(""),
                ),
              )
                  .then((value) {
                setState(() {
                  if (value == true) {
                    _getAddress();
                  }
                });
              });
            },
            child: const Text(
              '+ Add address',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: (isLoading)
          ? buildAddressShimmer()
          : (addressList.isNotEmpty)
              ? _mainWidget()
              : _noDataWidget(),
    );
  }

  Widget _mainWidget() {
    return ListView.builder(
      itemCount: addressList.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Card(
              margin: const EdgeInsets.all(13),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (addressList[index]['default'].toString() == '1')
                            Container(
                              height: 20,
                              width: 65,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: const Center(
                                child: Text(
                                  "DEFAULT",
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.white),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            addressList[index]['address_name'].toString(),
                            style: const TextStyle(
                                fontSize: 15.0, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("${addressList[index]['street_address']},"),
                          Text(
                              "${addressList[index]['area']}, ${addressList[index]['city']},"),
                          // Text(city.toString() + ","),
                          Text("${addressList[index]['state']},"),
                          Text(addressList[index]['country'].toString()),
                          Text(addressList[index]['pincode'].toString()),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Phone: ${addressList[index]['mob_no']}",
                            style: const TextStyle(
                                fontSize: 15.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => AddAddressScreen(
                                      addressList[index]['address_name']
                                          .toString()),
                                ),
                              )
                                  .then((value) {
                                if (value == true) {
                                  _getAddress();
                                }
                              });
                            },
                            child: const Text(
                              'Edit',
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.blue),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
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
                              _showAddressDelDialog(addressList[index]
                                      ['address_name']
                                  .toString());
                            },
                            child: const Text(
                              'Delete',
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.red),
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
    );
  }

  Widget _noDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: UiUtils.getScreenHeight(context, 0.4),
            child: UiUtils.getAssetImage(AppIcons.no_data_found),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Text(
              "You have no Address Yet!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey.shade800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
            child: Center(
              child: Text(
                "You can Add address by clicking on the ",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 2, 25, 5),
            child: Center(
              child: Text(
                "Add address Button",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
      ),
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
