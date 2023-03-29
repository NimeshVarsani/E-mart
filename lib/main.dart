import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:emart/screens/home_screen.dart';
import 'package:emart/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Emart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      );
      });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splash: Image.asset('assets/images/emart.jpg'),
      nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return MyHomeScreen();
            }
            else{
              return MyLoginPage();
            }
          }
      ),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 400.0,
    );

  }
}

class ColorAll {
  static const Color colorText = Colors.blueAccent;
  static  Color colorsPrimary = Colors.indigo.shade400;

}