import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  String text;
  String hintText;
  TextEditingController? controller;
  TextInputAction? textInputAction;
  TextInputType? keyBoardType;
  double containerHeight;
  VoidCallback? onTap;

  TextFieldWidget({
    Key? key,
    this.controller,
    this.textInputAction,
    // this.initialValue ="",
    this.text = '',
    this.hintText = '',
    this.containerHeight = 0,
    this.onTap,
    this.keyBoardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          height: containerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration:
          BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: TextField(
              keyboardType: keyBoardType,
              controller: controller,
              onTap: onTap,
              textInputAction: textInputAction,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                // hintStyle: AppDecoration.textStyle1(15.0, AppColors.hintTextColor),
                // suffixIcon: suffixIcon,
              )
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}


Widget labelName(String label){
  return Container(
    padding: const EdgeInsets.only(left: 5),
    child: Text(
      label,
      style: const TextStyle(fontSize: 16.0, color: Colors.black),
    ),
  );
}