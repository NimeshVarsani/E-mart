import 'dart:async';

import 'package:emart/main.dart';
import 'package:emart/utils/ui_utils.dart';
import 'package:emart/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AddAddressScreen extends StatefulWidget {
  AddAddressScreen(this.addressName, {Key? key}) : super(key: key);

  String addressName = "";

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _addressnameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalcodeController = TextEditingController();
  final TextEditingController _mobilenumberController = TextEditingController();

  bool isDefault = false;

  @override
  void initState() {
    super.initState();

    if (widget.addressName.isNotEmpty) {
      getAddress();
    }
  }

  getAddress() async {
    context.loaderOverlay.show();

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
      print('data=-=$data');
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
      UiUtils.showToast('No adress present');
    }

    if (mounted) {
      context.loaderOverlay.hide();
    }
  }

  Future<void> addAddress() async {
    print('add new called');
    var userId = FirebaseAuth.instance.currentUser?.uid;

    context.loaderOverlay.show();

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

    UiUtils.showToast('Address Added');
    if (mounted) {
      Navigator.of(context).pop(true);

      context.loaderOverlay.hide();
    }
  }

  Future<void> updateAddress() async {
    print('update called');
    var userId = FirebaseAuth.instance.currentUser?.uid;

    context.loaderOverlay.show();

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

    UiUtils.showToast('Address Added');
    Navigator.of(context).pop(true);

    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    var mainWidth = MediaQuery.of(context).size.width;
    var mainHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          backgroundColor: ColorAll.colorsPrimary,
          title: const Text('Add Address'),
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ),
        body: Container(
            // height: mainHeight,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 1,
                ),
                TextFieldWidget(
                  text: "Address Name",
                  hintText: "Enter Address Name",
                  containerHeight: 36,
                  controller: _addressnameController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 1,
                ),
                TextFieldWidget(
                  text: "Street Address",
                  hintText: "Flat No. or Building name",
                  containerHeight: 36,
                  controller: _streetController,
                  textInputAction: TextInputAction.next,
                ),
                TextFieldWidget(
                  text: "Area Name",
                  hintText: "Area name",
                  containerHeight: 36,
                  controller: _areaController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 1,
                ),
                TextFieldWidget(
                  text: "City",
                  hintText: "Enter City",
                  containerHeight: 36,
                  controller: _cityController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 1,
                ),
                TextFieldWidget(
                  text: "State",
                  hintText: "Enter State",
                  containerHeight: 36,
                  controller: _stateController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 1,
                ),
                TextFieldWidget(
                  text: "Country",
                  hintText: "Enter Country",
                  containerHeight: 36,
                  controller: _countryController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 1,
                ),
                TextFieldWidget(
                  text: "Postal Code",
                  hintText: "Enter Postal Code",
                  containerHeight: 36,
                  keyBoardType: TextInputType.number,
                  controller: _postalcodeController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 2,
                ),
                TextFieldWidget(
                  text: "Mobile Number",
                  hintText: "Enter Mobile Number",
                  containerHeight: 36,
                  keyBoardType: TextInputType.number,
                  controller: _mobilenumberController,
                  textInputAction: TextInputAction.next,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
                      if (_addressnameController.text.isNotEmpty &&
                          _streetController.text.isNotEmpty &&
                          _areaController.text.isNotEmpty &&
                          _cityController.text.isNotEmpty &&
                          _stateController.text.isNotEmpty &&
                          _countryController.text.isNotEmpty &&
                          _postalcodeController.text.isNotEmpty &&
                          _mobilenumberController.text.isNotEmpty) {
                        if (widget.addressName.isNotEmpty) {
                          updateAddress();
                        } else {
                          addAddress();
                        }
                      } else {
                        UiUtils.showToast('Please enter all Fields');
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
                ),
              ]),
            )));
  }
}
