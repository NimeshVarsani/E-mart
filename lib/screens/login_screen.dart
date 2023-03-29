import 'dart:async';

import 'package:emart/auth_service.dart';
import 'package:emart/main.dart';
import 'package:emart/screens/home_screen.dart';
import 'package:emart/screens/sign_up_screen.dart';
import 'package:emart/utils/strings.dart';
import 'package:emart/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

// BuildContext? ctxLS;
var ctxProgressL;

class MyLoginPage extends StatelessWidget {
  MyLoginPage({Key? key}) : super(key: key);

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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Login screen',
            home: ProgressHUD(
              backgroundColor: Colors.white,
              indicatorColor: ColorAll.colorsPrimary,
              textStyle: TextStyle(
                color: ColorAll.colorsPrimary,
                fontSize: 18.sp,
              ),
              child: Builder(
                builder: (ctxProg) => LoginScreen(ctxProg),
              ),
            ),
          );
        });
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen(BuildContext ctxProg, {Key? key}) : super(key: key) {
    ctxProgressL = ctxProg;
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var progress;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mainWidth = MediaQuery.of(context).size.width;
    var mainHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.white38,
        height: mainHeight,
        padding: EdgeInsets.only(top: 50, left: 22, right: 22),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Image.asset(
                      'assets/images/logo_new.png',
                      fit: BoxFit.cover,
                      scale: 0.8,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 45, bottom: 10),
                  child: const Text(
                    'Welcome to M-mart',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 35),
                  child: Text(
                    'Login to your account',
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
                      // labelText: 'Email',
                      // labelStyle: TextStyle(color: Colors.black54),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.black54),
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
                    top: 18,
                    bottom: 8,
                  ),
                  child: TextField(
                    controller: _passwordController,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.done,
                    obscureText: !_passwordVisible,
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
                        Icons.lock,
                        color: ColorAll.colorsPrimary,
                      ),
                      // labelText: 'Password',
                      // labelStyle: TextStyle(color: Colors.black54),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.black54),
                      contentPadding: const EdgeInsets.only(
                          left: 18.0, bottom: 8.0, top: 8.0),
                      fillColor: Colors.grey[100],
                      filled: true,
                      suffixIcon: IconButton(
                        icon: _passwordVisible
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
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
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(
                    top: 5,
                    right: 14,
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 50,
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          // side: BorderSide(color: Colors.black)
                        ))),
                    onPressed: () {
                      _emailController.text = 'nimeshinvest1@gmail.com';
                      _passwordController.text = 'nim123';
                      // _emailController.text = 'nimeshvarsani7@gmail.com';
                      // _passwordController.text = 'nim123';
                      login();
                    },
                    child: const Text(
                      Strings.login,
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
                      'Don\'t have an account? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MySignUpScreen(context)));
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: ColorAll.colorsPrimary,
                            fontSize: 16.0),
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Or',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0),
                  ),
                ),

                SignInButton(
                  Buttons.Google,
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  text: "Sign up with Google",
                  onPressed: () async{
                    User? user = await AuthService().signInWithGoogle(ctxProgressL);

                    if(user != null){
                      print('user exists=-=-=-=');

                      try {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MyHomeScreen(),
                          ),
                              (route) => false,
                        );
                      }catch(e){
                        print(e);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressL);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (user.user != null) {
          Util.showSnackBar(context, 'Logged In Successfully');
          Timer(const Duration(milliseconds: 22), () {
            progress.dismiss();
          });

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MyHomeScreen(),
            ),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print(e);
        }
        progress.dismiss();
        Util.showSnackBar(context, 'Invalid credentials');
      }
    } else {
      progress.dismiss();
      Util.showSnackBar(context, 'please enter all fields');
    }
  }
}
