import 'dart:async';

import 'package:emart/main.dart';
import 'package:emart/utils/utils.dart';
import 'package:emart/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BuildContext? ctxAA;
var ctxProgressAA;

class AddAddressScreen extends StatelessWidget {
  AddAddressScreen(BuildContext ctxLS1, this.addressName, {Key? key})
      : super(key: key) {
    ctxAA = ctxLS1;
  }

  String addressName = "";

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
              builder: (ctxProg) => MyAddAddressScreen(ctxProg, addressName),
            ),
          );
        });
  }
}

class MyAddAddressScreen extends StatefulWidget {
  MyAddAddressScreen(BuildContext ctxProg, this.addressName, {Key? key})
      : super(key: key) {
    ctxProgressAA = ctxProg;
  }

  String addressName = "";

  @override
  State<MyAddAddressScreen> createState() => _MyAddAddressScreenState();
}

class _MyAddAddressScreenState extends State<MyAddAddressScreen> {
  var progress;
  TextEditingController _addressnameController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _postalcodeController = TextEditingController();
  TextEditingController _mobilenumberController = TextEditingController();

  bool isDefault = false;

  @override
  void initState() {
    super.initState();

    if (widget.addressName.isNotEmpty) {
      getAddress();
    }
  }

  getAddress() async {
    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressAA);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    var userId = FirebaseAuth.instance.currentUser?.uid;
    var dbRef = FirebaseDatabase.instance
        .ref()
        .child('users/$userId/address/${widget.addressName}');
    DatabaseEvent event = await dbRef.once();
    print(event.snapshot.exists);

    if (event.snapshot.exists) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      print('data=-=' + data.toString());
      setState(() {
        _addressnameController.text = data['address_name'];
        _streetController.text = data['street_address'];
        _areaController.text = data['area'];
        _cityController.text = data['city'];
        _stateController.text = data['state'];
        _countryController.text = data['country'];
        _postalcodeController.text = data['pincode'];
        _mobilenumberController.text = data['mob_no'];
        isDefault = (data['default'].toString() == '1') ? true : false;
      });


      print('address_name=-=' + data['address_name']);
      print('street_address=-=' + data['street_address']);
      print('city=-=' + data['city']);
      print('country=-=' + data['country']);
      print('pincode=-=' + data['pincode']);
      print('mob_no=-=' + data['mob_no']);
    } else {
      Util.showToast('No adress present');
    }

    Timer(const Duration(milliseconds: 20), () {
      progress.dismiss();
    });
  }

  Future<void> addAddress() async {
    print('add new called');
    var userId = FirebaseAuth.instance.currentUser?.uid;
    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressAA);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    var ref = FirebaseDatabase.instance.ref().child(
        'users/$userId/address/${_addressnameController.text.toString()}');
    await ref.set({
      'address_name': _addressnameController.text.toString(),
      'street_address': _streetController.text.toString(),
      'area': _areaController.text.toString(),
      'city': _cityController.text.toString(),
      'state': _stateController.text.toString(),
      'country': _countryController.text.toString(),
      'pincode': _postalcodeController.text.toString(),
      'mob_no': _mobilenumberController.text.toString(),
      'default': (isDefault) ? '1' : '0',
    });

    Util.showToast('Address Added');
    Navigator.of(ctxAA!).pop(true);
    Timer(const Duration(milliseconds: 20), () {
      progress.dismiss();
    });
  }

  Future<void> updateAddress() async {
    print('update called');
    var userId = FirebaseAuth.instance.currentUser?.uid;
    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressAA);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    var ref = FirebaseDatabase.instance.ref().child(
        'users/$userId/address/${_addressnameController.text.toString()}');
    await ref.update({
      'address_name': _addressnameController.text.toString(),
      'street_address': _streetController.text.toString(),
      'area': _areaController.text.toString(),
      'city': _cityController.text.toString(),
      'state': _stateController.text.toString(),
      'country': _countryController.text.toString(),
      'pincode': _postalcodeController.text.toString(),
      'mob_no': _mobilenumberController.text.toString(),
      'default': (isDefault) ? '1' : '0',
    });

    Util.showToast('Address Added');
    Navigator.of(ctxAA!).pop(true);
    Timer(const Duration(milliseconds: 20), () {
      progress.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    var mainWidth = MediaQuery.of(context).size.width;
    var mainHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          backgroundColor: ColorAll.colorsPrimary,
          title: Text('Add Address'),
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(ctxAA!).pop(false);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            // height: mainHeight,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                TextFieldWidget(
                  text: "Address Name",
                  hintText: "Enter Address Name",
                  containerHeight: 36.h,
                  controller: _addressnameController,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFieldWidget(
                  text: "Street Address",
                  hintText: "Flat No. or Building name",
                  containerHeight: 36.h,
                  controller: _streetController,
                  textInputAction: TextInputAction.next,
                ),
                TextFieldWidget(
                  text: "Area Name",
                  hintText: "Area name",
                  containerHeight: 36.h,
                  controller: _areaController,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFieldWidget(
                  text: "City",
                  hintText: "Enter City",
                  containerHeight: 36.h,
                  controller: _cityController,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFieldWidget(
                  text: "State",
                  hintText: "Enter State",
                  containerHeight: 36.h,
                  controller: _stateController,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFieldWidget(
                  text: "Country",
                  hintText: "Enter Country",
                  containerHeight: 36.h,
                  controller: _countryController,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFieldWidget(
                  text: "Postal Code",
                  hintText: "Enter Postal Code",
                  containerHeight: 36.h,
                  keyBoardType: TextInputType.number,
                  controller: _postalcodeController,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextFieldWidget(
                  text: "Mobile Number",
                  hintText: "Enter Mobile Number",
                  containerHeight: 36.h,
                  keyBoardType: TextInputType.number,
                  controller: _mobilenumberController,
                  textInputAction: TextInputAction.next,
                ),
                // SizedBox(
                //   height: 2.h,
                // ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: CheckboxListTile(
                    title: const Text('Make as Default Address'),
                    autofocus: false,
                    activeColor: ColorAll.colorsPrimary,
                    controlAffinity: ListTileControlAffinity.leading,

                    checkColor: Colors.white,
                    value: isDefault,
                    onChanged: (value) {
                      setState(() {
                        isDefault = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: mainWidth / 2.5,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorAll.colorsPrimary)),
                    onPressed: () async {

                      if(_addressnameController.text.isNotEmpty &&
                          _streetController.text.isNotEmpty &&
                          _areaController.text.isNotEmpty &&
                          _cityController.text.isNotEmpty &&
                          _stateController.text.isNotEmpty &&
                          _countryController.text.isNotEmpty &&
                          _postalcodeController.text.isNotEmpty &&
                          _mobilenumberController.text.isNotEmpty){

                        if (widget.addressName.isNotEmpty) {
                          updateAddress();
                        } else {
                          addAddress();
                        }

                      }else{
                        Util.showToast('Please enter all Fields');
                      }

                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
