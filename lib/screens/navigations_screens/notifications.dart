import 'package:emart/main.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/notifications.jpg', height: 180,),
              const SizedBox(height: 25.0,),
              const Text('You have No Notifications'),

            ],
          ),
        ),
      ),
    );
  }
}