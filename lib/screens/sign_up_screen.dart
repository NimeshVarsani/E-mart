import 'dart:async';
import 'package:emart/screens/home_screen.dart';
import 'package:emart/main.dart';
import 'package:emart/utils/strings.dart';
import 'package:emart/utils/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MySignUpScreen extends StatefulWidget {
  const MySignUpScreen({Key? key}) : super(key: key);

  @override
  State<MySignUpScreen> createState() => _MySignUpScreenState();
}

class _MySignUpScreenState extends State<MySignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> addUser(String name, String email, String uid) async {
    var ref = FirebaseDatabase.instance.ref().child('users/$uid');
    await ref.set({
      "name": name,
      "email": email,
      "uid": uid,
    });
  }

  Future signUp() async {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      if (_passwordController.text.toString().trim() ==
          _confirmPasswordController.text.toString().trim()) {
        try {
          context.loaderOverlay.show();

          //fetching list of email in database
          final list = await FirebaseAuth.instance
              .fetchSignInMethodsForEmail(_emailController.text.trim());
          //checking user typed mail in database
          if (list.isNotEmpty) {
            //email is already in use
            if (mounted) {
              UiUtils.showSnackBar(context, 'Email is already in use');
              context.loaderOverlay.hide();
            }
          } else {
            //email is not in use so we can create user
            final newUser =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

            var userId = (FirebaseAuth.instance.currentUser?.uid ?? "");
            addUser(_nameController.text.toString(),
                _emailController.text.toString(), userId);

            //for verification of user
            if (newUser.user != null) {
              if (mounted) {
                context.loaderOverlay.hide();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MyHomeScreen(),
                  ),
                  (route) => false,
                );
              }
            }
          }
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print(e);
          }
          //email is already in use
          UiUtils.showSnackBarLong(
              context, 'Invalid Email address or make strong password');
          context.loaderOverlay.hide();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } else {
        UiUtils.showSnackBar(context, 'Passwords Mismatched');
      }
    } else {
      UiUtils.showSnackBar(context, 'please enter all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    var mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorAll.colorsPrimary,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: UiUtils.getScreenHeight(context, 0.06),
            left: 22,
            right: 22,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 35),
                child: const Text(
                  'Create your new account',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                width: mainWidth,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 8,
                ),
                child: TextField(
                  controller: _nameController,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  cursorColor: Colors.black45,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: ColorAll.colorsPrimary,
                    ),
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.black54),
                    contentPadding: const EdgeInsets.only(
                        left: 18.0, bottom: 8.0, top: 8.0),
                    fillColor: Colors.grey[100],
                    filled: true,
                    border: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorAll.colorsPrimary, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Container(
                width: mainWidth,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 8,
                ),
                child: TextField(
                  controller: _emailController,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  cursorColor: Colors.black45,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: ColorAll.colorsPrimary,
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.black54),
                    contentPadding: const EdgeInsets.only(
                        left: 18.0, bottom: 8.0, top: 8.0),
                    fillColor: Colors.grey[100],
                    filled: true,
                    border: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorAll.colorsPrimary, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Container(
                width: mainWidth,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 8,
                ),
                child: TextField(
                  controller: _passwordController,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  obscureText: !_passwordVisible,
                  autofocus: false,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  cursorColor: Colors.black45,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // labelText: 'Password',
                    // labelStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: ColorAll.colorsPrimary,
                    ),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.black54),
                    contentPadding: const EdgeInsets.only(
                        left: 18.0, bottom: 8.0, top: 8.0),
                    fillColor: Colors.grey[100],
                    filled: true,
                    suffixIcon: IconButton(
                      icon: _passwordVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorAll.colorsPrimary, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Container(
                width: mainWidth,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 8,
                ),
                child: TextField(
                  controller: _confirmPasswordController,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  obscureText: !_confirmPasswordVisible,
                  autofocus: false,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  cursorColor: Colors.black45,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // labelText: 'Password',
                    // labelStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: ColorAll.colorsPrimary,
                    ),
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(color: Colors.black54),
                    contentPadding: const EdgeInsets.only(
                        left: 18.0, bottom: 8.0, top: 8.0),
                    fillColor: Colors.grey[100],
                    filled: true,
                    suffixIcon: IconButton(
                      icon: _confirmPasswordVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorAll.colorsPrimary, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 80,
                  // left: 10,
                  // right: 10,
                  bottom: 8,
                ),
                width: mainWidth,
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorAll.colorsPrimary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        // side: BorderSide(color: Colors.black)
                      ))),
                  onPressed: () {
                    // _nameController.text = 'Nimesh';
                    // _emailController.text = 'nimeshvarsani7@gmail.com';
                    // _passwordController.text = 'nim123';
                    // _confirmPasswordController.text = 'nim123';
                    signUp();
                  },
                  child: const Text(
                    Strings.signUp,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Login In',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: ColorAll.colorsPrimary,
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
