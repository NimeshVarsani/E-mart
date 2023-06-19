import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:emart/main.dart';
import 'package:emart/models/products.dart';
import 'package:emart/utils/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BuildContext? ctxPD;
var ctxProgressPD;

class ProductDetails extends StatelessWidget {
  ProductDetails(BuildContext ctxLS1, this.productIndex, {Key? key})
      : super(key: key) {
    ctxPD = ctxLS1;
  }

  final int productIndex;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ProgressHUD(
            backgroundColor: Colors.white,
            indicatorColor: ColorAll.colorsPrimary,
            textStyle: TextStyle(
              color: ColorAll.colorsPrimary,
              fontSize: 18.sp,
            ),
            child: Builder(
              builder: (ctxProg) => MyProductDetails(ctxProg, productIndex),
            ),
          );
        });
  }
}

class MyProductDetails extends StatefulWidget {
  MyProductDetails(BuildContext ctxProg, this.productIndex, {Key? key})
      : super(key: key) {
    ctxProgressPD = ctxProg;
  }

  int? productIndex;

  @override
  State<MyProductDetails> createState() => _MyProductDetailsState();
}

class _MyProductDetailsState extends State<MyProductDetails> {
  var progress;
  List<Products> productsDetailList = [];
  int _current = 0;
  int _quantity = 1;

  String productThumbnailImage = "";
  String productTitle = "";
  String productPrice = "";
  int productPriceSub = 0;
  String productDescription = "";
  String productBrand = "";
  String productDiscount = "";
  String productCategory = "";
  String productId = "";
  double productRating = 0;
  List productImageList = [];

  @override
  void initState() {
    super.initState();
    productDetailData();
  }

  Future<void> addProductToCart(String productIndex, String uid) async {
    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressPD);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    var ref = FirebaseDatabase.instance
        .ref()
        .child('users/$uid/cart/products/$productId');
    await ref.set({
      'productId': productId,
      'brand': productBrand,
      'category': productCategory,
      'description': productDescription,
      'discountPercentage': productDiscount,
      'price': productPrice,
      'thumbnail': productThumbnailImage,
      'title': productTitle,
      'quantity': _quantity.toString(),
      'rating': productRating,
    });

    Timer(const Duration(milliseconds: 20), () {
      progress.dismiss();
    });

    UiUtils.showToast('Added to cart');
  }

  productDetailData() async {
    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressPD);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    var dbRef = FirebaseDatabase.instance
        .ref()
        .child('new_products/products/${widget.productIndex}');
    DatabaseEvent event = await dbRef.once();

    if (event.snapshot.exists) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      print('data=-=$data');

      setState(() {
        productRating = data['rating'];
        productTitle = data['title'];
        productPrice = data['price'].toString();
        productPriceSub = (data['price'] + 20);
        productDescription = data['description'];
        productThumbnailImage = data['thumbnail'];
        productBrand = data['brand'];
        productDiscount = data['discountPercentage'].toString();
        productCategory = data['category'];
        productId = data['id'].toString();
        productImageList = data['images'];
      });


      print('title=-=' + data['title']);
      print('price=-=${data['price']}');
      print('description=-=' + data['description']);
      print('images=-=${data['images']}');
    }

    Timer(const Duration(milliseconds: 20), () {
      progress.dismiss();
    });
  }

  /*productDetailData() async {
    Timer(const Duration(milliseconds: 15), () {
      progress = ProgressHUD.of(ctxProgressPD);
      progress.show();

      Timer(const Duration(seconds: 15), () {
        progress.dismiss();
      });
    });

    String url =
        'https://m-mart-a9dc4-default-rtdb.firebaseio.com/new_products.json';
    http.Response response = await http.get(Uri.parse(url));

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    print("taskdata "
        "response=----->$responseJson");

    ProductsModel productsModel = ProductsModel.fromJson(responseJson);

    productsDetailList.clear();
    productsModel.products?.forEach((element) {
      setState(() {
        productsDetailList.add(element);
      });
    });

    setState(() {
      items.clear();
      items = productsDetailList[widget.productIndex!].images ?? [];

      productThumbnailImage = productsDetailList[widget.productIndex!].thumbnail.toString();

      productTitle = productsDetailList[widget.productIndex!].title.toString();
      productPrice = productsDetailList[widget.productIndex!].price.toString();
      productPriceSub = productsDetailList[widget.productIndex!].price! - 12;
      productDescription = productsDetailList[widget.productIndex!].description.toString();
      productBrand = productsDetailList[widget.productIndex!].brand.toString();
      productDiscount = productsDetailList[widget.productIndex!].discountPercentage.toString();
      productCategory = productsDetailList[widget.productIndex!].category.toString();
      productId = productsDetailList[widget.productIndex!].id.toString();
    });

    print('product titl=-=-' + productsDetailList[0].title.toString());

    Timer(const Duration(milliseconds: 20), () {
      progress.dismiss();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    var mainWidth = MediaQuery
        .of(context)
        .size
        .width;
    var mainHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorAll.colorsPrimary,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(ctxPD!);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text(
            "PRODUCT DETAILS",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryWidget(
                      imgList: image.toList(),
                    ),
                  ),
                );*/
                },
                child: CarouselSlider(
                  items: productImageList
                      .map((e) =>
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.sp,
                          ),
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/default_img.jpg",
                          fit: BoxFit.cover,
                          // width: 40,
                          // height: 40,
                          image: (e),
                        ),
                      ),
                  ).toList(),
                  options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                          print("$_current");
                        });
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: productImageList.map(
                      (image) {
                    int index = productImageList.indexOf(image);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? const Color.fromRGBO(0, 0, 0, 0.9)
                              : const Color.fromRGBO(0, 0, 0, 0.4)),
                    );
                  },
                ).toList(), // this was the part the I had to add
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      productDescription,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 10),
                    RatingBarIndicator(
                      rating: productRating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 28.0,
                      direction: Axis.horizontal,
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '\$$productPrice',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '\$$productPriceSub',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade500,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$productDiscount% off',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _quantity++),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      'Price inclusive of all taxes.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: SizedBox(
                        width: mainWidth / 1.8,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 13,
                            ),
                          ),
                          child: const Text(
                            'Buy',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: SizedBox(
                        width: mainWidth / 1.8,
                        child: ElevatedButton(
                          onPressed: () {
                            addProductToCart(widget.productIndex.toString(),
                                FirebaseAuth.instance.currentUser!.uid);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 13,
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
