import 'package:emart/screens/login_screen.dart';
import 'package:emart/screens/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 34,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: 43,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                signUp();
              },
              child: const Text(
                'SIGN UP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: Text(
                  'Login In',
                  style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 16.0
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future signUp() async {
    //checking for an empty text-fields
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        //fetching list of email in database
        final list = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(_emailController.text.trim());

        //checking user typed mail in database
        if (list.isNotEmpty) {
          //email is already in use
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Email is already in use"),
          ));
        } else {
          //email is not in use so we can create user
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          //for verification of user email
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const VerifyEmailPage()));

        }
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print(e);
        }
        //email is already in use
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid Email address"),
        ));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("please enter all fields"),
      ));
    }
  }
}
