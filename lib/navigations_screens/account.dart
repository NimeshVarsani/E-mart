import 'package:emart/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  Widget cardList(BuildContext context) {
    List<String> items = [
      'Orders',
      'Customer Care',
      'Saved Cards',
      'My Rewards',
      'Address',
      'Returns & Refunds Policy',
      'We Respect Your Privacy',
      'Fees & Payments',
      'Who We Are',
    ];

    return Expanded(
      child: ListView.builder(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(items[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 6.5,
                color: Colors.blueGrey[50],
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(
                            'https://freesvg.org/img/abstract-user-flat-4.png'),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nimesh',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text('${FirebaseAuth.instance.currentUser?.email}'),
                      ],
                    ),
                  ],
                ),
              ),
              cardList(context),
              Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.black, width: 0.3)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const LoginScreen()));                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Logged Out Successfully"),
                    ));
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
