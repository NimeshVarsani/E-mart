import 'package:emart/auth_service.dart';
import 'package:emart/main.dart';
import 'package:emart/screens/home_screen.dart';
import 'package:emart/screens/sign_up_screen.dart';
import 'package:emart/utils/strings.dart';
import 'package:emart/utils/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    var mainWidth = MediaQuery.of(context).size.width;
    var mainHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white38,
          height: mainHeight,
          padding: EdgeInsets.only(
            top: UiUtils.getScreenHeight(context, 0.04),
            left: 22,
            right: 22,
          ),
          child: Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Image.asset(
                    'assets/images/logo_new.png',
                    fit: BoxFit.cover,
                    scale: 0.8,
                  )),
              Container(
                margin: const EdgeInsets.only(top: 45, bottom: 10),
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
                margin: const EdgeInsets.only(bottom: 35),
                child: const Text(
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
                    hintStyle: const TextStyle(color: Colors.black54),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        // side: BorderSide(color: Colors.black)
                      ))),
                  onPressed: () {
                    _emailController.text = 'adminemart@gmail.com';
                    _passwordController.text = 'admin@123!';
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
                              builder: (context) => const MySignUpScreen()));
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Text(
                  'Or',
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
              SignInButton(
                Buttons.Google,
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                text: "Sign up with Google",
                onPressed: () async {
                  context.loaderOverlay.show();

                  User? user = await AuthService().signInWithGoogle();

                  if (user != null) {
                    if (mounted) {
                      context.loaderOverlay.hide();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const MyHomeScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    context.loaderOverlay.show();

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (user.user != null) {
          if (mounted) {
            context.loaderOverlay.hide();

            UiUtils.showSnackBar(context, 'Logged In Successfully');

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const MyHomeScreen(),
              ),
              (route) => false,
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print(e);
        }
        context.loaderOverlay.hide();
        UiUtils.showSnackBar(context, 'Invalid credentials');
      }
    } else {
      context.loaderOverlay.hide();
      UiUtils.showSnackBar(context, 'please enter all fields');
    }
  }
}
