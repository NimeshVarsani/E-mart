import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:emart/screens/home_screen.dart';
import 'package:emart/screens/login_screen.dart';
import 'package:emart/utils/app_icons.dart';
import 'package:emart/utils/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      duration: const Duration(seconds: 2),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Emart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splash: UiUtils.getAssetImage(
        AppIcons.splash_logo,
        width: UiUtils.getScreenWidth(context, 0.5),
      ),
      nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MyHomeScreen();
            } else {
              return const MyLoginPage();
            }
          }),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 400.0,
    );
  }
}

class ColorAll {
  static const Color colorText = Colors.blueAccent;
  static Color colorsPrimary = Colors.indigo.shade400;
}
