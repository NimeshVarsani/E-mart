import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2874F0),
        elevation: 0,
        title: const Text('All Categories'),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mic),
              ))
        ],
      ),
      body: const SafeArea(
        child: Center(
          child: Text('All Categories are shown here'),
        ),
      ),
    );
  }
}
