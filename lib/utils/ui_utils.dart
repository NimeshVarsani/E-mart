import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtils {
  static showCustomDialog(
      {required BuildContext context,
      required String title,
      required String yesButtonText,
      required String cancelButtonText,
      required Function() signOut}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            title: _headerWidget(
              title: title,
            ),
            actions: [
              _yesButtonWidget(
                  context: context,
                  yesButtonText: yesButtonText,
                  signOut: signOut),
              _cancelButtonWidget(
                  context: context, cancelButtonText: cancelButtonText),
            ],
          );
        });
  }

  static Text _headerWidget({required String title, double? fontSize}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize ?? 19,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
      textAlign: TextAlign.center,
    );
  }

  static Widget _yesButtonWidget(
      {required BuildContext context,
      required String yesButtonText,
      required Function() signOut}) {
    return Center(
      child: SizedBox(
        width: UiUtils.getScreenWidth(context, 0.8),
        child: OutlinedButton(
          onPressed: () {
            signOut();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            shape: const StadiumBorder(),
          ),
          child: Text(
            yesButtonText,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  static Container _cancelButtonWidget(
      {required BuildContext context, required String cancelButtonText}) {
    return Container(
      // width: double.maxFinite,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
        ),
        child: Text(
          cancelButtonText,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  static double getScreenWidth(BuildContext context, double value) {
    return MediaQuery.of(context).size.width * value;
  }

  static double getScreenHeight(
    BuildContext context,
    double value,
  ) {
    return MediaQuery.of(context).size.height * value;
  }

  static Image getAssetImage(String path,
      {Color? color, BoxFit? fit, double? height, double? width}) {
    return Image.asset(
      path,
      height: height,
      width: width,
      color: color,
      fit: fit ?? BoxFit.contain,
    );
  }

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
        msg: string,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showSnackBar(BuildContext context, String message) {
    var snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSnackBarLong(BuildContext context, String message) {
    var snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 8),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget makeCard(String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0.8),
      elevation: 0,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 13),
        ),
        trailing: const ImageIcon(
          AssetImage(
            'assets/icons/right.png',
          ),
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }

  Widget makeCardWithTap(
      BuildContext context, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0.8),
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(fontSize: 13),
        ),
        trailing: const ImageIcon(
          AssetImage(
            'assets/icons/right.png',
          ),
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }

  Widget labelName(String label) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 5, bottom: 6),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );
  }
}
