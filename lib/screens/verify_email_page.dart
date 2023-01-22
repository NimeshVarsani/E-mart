import 'dart:async';

import 'package:emart/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {

  bool _isEmailVerified = false;
  Timer? timer;

  @override
  void initState(){
    super.initState();

    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!_isEmailVerified){
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
    }

  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _isEmailVerified
      ?const HomeScreen()
      : Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('A Verification mail has been sent to your email', style: TextStyle(fontSize: 18.0),),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            height: 43,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                sendVerificationEmail();
              },
              child: const Text(
                'Resent Email',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );


  Future sendVerificationEmail() async{
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    }catch(e){
      if (kDebugMode) {
        print(e);
      }    }
  }

  Future checkEmailVerified() async{
    //call after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState((){
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(_isEmailVerified) timer?.cancel();
  }

}
