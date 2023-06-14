import 'package:emart/main.dart';
import 'package:emart/utils/ui_utils.dart';
import 'package:emart/widgets/shimmerLoadingContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  bool isCartLoaded = false;
  List cartList = [];

  int _quantity = 0;

  final _dbRef = FirebaseDatabase.instance
      .ref()
      .child('users/${FirebaseAuth.instance.currentUser!.uid}/cart/products');

  @override
  void initState() {
    super.initState();
    // _getCartData();
  }

  _getCartData() async {
    cartList.clear();
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('users/${FirebaseAuth.instance.currentUser?.uid}/cart/products');

    databaseReference.once().then((snapshot) {
      // final data = Map<String, dynamic>.from(
      //   snapshot.snapshot.value as Map,
      // );
      var list = snapshot.snapshot.value;
      setState(() {
        // cartList = data.values.toList(growable: true);
        isCartLoaded = true;
      });
      print('listlist=-=>' + list.toString());
      print('list=-=>' + cartList.toString());
      // print('list=-=>' + cartList[0]['brand'].toString());
    });
  }

  _showCartDelDialog(String pId) async {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure you want to Remove Item?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _dbRef.child(pId).remove();
                  _getCartData();
                  UiUtils.showToast('Product Removed');

                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
  }

  Widget buildCartShimmer() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: double.infinity,
                  child: const Row(
                    children: [
                      CustomShimmer(height: 100, width: 100,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomShimmer(height: 10, width: 100, margin: EdgeInsets.symmetric(horizontal: 14),),
                            SizedBox(
                              height:10,
                            ),
                            CustomShimmer(height: 10, width: 60,margin: EdgeInsets.symmetric(horizontal: 14),),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 28),
        child: Column(
          children: [
            AppBar(
              title: Text('Cart'),
              backgroundColor: ColorAll.colorsPrimary,
            ),
            (isCartLoaded) ? (cartList.isNotEmpty) ?
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 5,bottom: 33, left: 4, right: 4),
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100.0,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    cartList[index]['thumbnail'].toString(),
                                      // snapshot.child('thumbnail').value.toString(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    cartList[index]['title'].toString(),
                                    // snapshot.child('title').value.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '\$${cartList[index]['price'].toString()}',
                                    // '\$${snapshot.child('price').value.toString()}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  *//*Row(
                                    children: [
                                      IconButton(
                                        onPressed: _quantity > 1
                                            ? () => setState(() => _quantity = _quantity-1)
                                            : null,
                                        icon: Icon(Icons.remove_circle_outline),
                                      ),
                                      Text(
                                        '$_quantity',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => setState(() => _quantity = _quantity + 1),
                                        icon: Icon(Icons.add_circle_outline),
                                      ),
                                    ],
                                  ),*//*
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: (){
                                  // _showCartDelDialog(snapshot.child('productId').value.toString());
                                  _showCartDelDialog(cartList[index]['productId'].toString(),);
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    );
                    *//*Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/cart.png',
                            height: 150,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          const Text(
                            'Your cart is empty!',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                MaterialStateProperty.all(const Color(0xff2874F0)),
                              ),
                              onPressed: () {
                                BottomNavigationBar navigationBar = bottomWidgetKey
                                    .currentWidget as BottomNavigationBar;
                                navigationBar.onTap!(0);
                              },
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
                    );*//*
                  }),
            ) : noDataFound(context) : Expanded(child: buildCartShimmer()),
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 28),
        child: Column(
          children: [
            AppBar(
              title: const Text('Cart'),
              backgroundColor: ColorAll.colorsPrimary,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: buildCartShimmer(),
                  padding: const EdgeInsets.only(top: 5,bottom: 33, left: 4, right: 4),
                  query: _dbRef,
                  itemBuilder: (context, snapshot, animation, index) {
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100.0,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(8.0),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.child('thumbnail').value.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.child('title').value.toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '\$${snapshot.child('price').value.toString()}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    /*Row(
                                    children: [
                                      IconButton(
                                        onPressed: _quantity > 1
                                            ? () => setState(() => _quantity = _quantity-1)
                                            : null,
                                        icon: Icon(Icons.remove_circle_outline),
                                      ),
                                      Text(
                                        '$_quantity',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => setState(() => _quantity = _quantity + 1),
                                        icon: Icon(Icons.add_circle_outline),
                                      ),
                                    ],
                                  ),*/
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: (){
                                    _showCartDelDialog(snapshot.child('productId').value.toString());
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    /* Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/cart.png',
                            height: 150,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          const Text(
                            'Your cart is empty!',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                MaterialStateProperty.all(const Color(0xff2874F0)),
                              ),
                              onPressed: () {
                                BottomNavigationBar navigationBar = bottomWidgetKey
                                    .currentWidget as BottomNavigationBar;
                                navigationBar.onTap!(0);
                              },
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
                    ); */
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
