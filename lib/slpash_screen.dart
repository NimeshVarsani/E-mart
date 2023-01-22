import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:emart/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
        splash: Image.asset('assets/emart.jpg'),
        nextScreen: const MainPage(),
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: 400.0,
    );

  }
}
