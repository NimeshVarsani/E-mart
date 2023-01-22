import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff2874F0),
        title: const Text('My Cart'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/cart.png', height: 150,),
              const SizedBox(height: 25.0,),
              const Text('Your cart is empty!', style: TextStyle(fontSize: 22,),),
              const SizedBox(height: 40.0,),

              Container(
                width: MediaQuery.of(context).size.width/1.8,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(const Color(0xff2874F0)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Shop now',
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
        ),
      ),
      );
  }
}