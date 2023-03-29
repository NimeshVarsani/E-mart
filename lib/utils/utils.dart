import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Util {

  static void showToast(String string) {
    Fluttertoast.showToast(
        msg: string,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showToastLong(String string) {
    Fluttertoast.showToast(
        msg: "$string",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showSnackBar(BuildContext context, String message) {
    var snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 5),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSnackBarLong(BuildContext context, String message) {
    var snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 8),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget makeCard(String title){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0.8),
      elevation: 0,
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 13.sp),),
        trailing: ImageIcon(AssetImage('assets/icons/right.png',), color: Colors.black, size: 20,),
      ),
    );
  }

  Widget makeCardWithTap(BuildContext context, String title, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0.8),
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: TextStyle(fontSize: 13.sp),),
        trailing: ImageIcon(
          AssetImage('assets/icons/right.png',), color: Colors.black,
          size: 20,),
      ),
    );
  }

  Widget labelName(String label){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 5, bottom: 6),
      child: Text(
        label,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );
  }

}