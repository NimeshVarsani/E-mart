import 'dart:convert';

import 'package:emart/main.dart';
import 'package:emart/models/products.dart';
import 'package:emart/screens/navigations_screens/home/product_details.dart';
import 'package:emart/widgets/noDataFound.dart';
import 'package:emart/widgets/shimmerLoadingContainer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var ctxProgressH;

class MyHome extends StatelessWidget {
  MyHome({Key? key}) : super(key: key);

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
              builder: (ctxProg) => Home(ctxProg),
            ),
          );
        });
  }
}

class Home extends StatefulWidget {
  Home(BuildContext ctxProg, {Key? key}) : super(key: key) {
    ctxProgressH = ctxProg;
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List productsList = [];
  List searchProductsList = [];
  List filteredList = [];
  var progress;
  bool isLoaded = false;

  final _focusNode = FocusNode();
  bool _keyboardVisible = false;

  TextEditingController searchController = TextEditingController();

  // final dbRef = FirebaseDatabase.instance.ref().child('new_products/products');

  final List<String> filterNames = [
    'Category',
    'Brand',
    'Color',
    'Price',
  ];

  final Map<String, List<String>> filterValues = {
    'Category': [
      'smartphones',
      'laptops',
      'fragrances',
      'skincare',
      'groceries',
      'home-decoration'
    ],
    'Brand': ['Apple', 'OPPO', 'Royal_Mirage', 'Reebok'],
    'Color': ['Red', 'Blue', 'Green', 'Yellow'],
    'Price': ['Below 500', '500 - 1000', '1000 - 2000', 'Above 2000'],
  };

  String selectedFiltersType = "Category";
  List selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _keyboardVisible = _focusNode.hasFocus;
        if (!_keyboardVisible) {
          print('unfocus=-=-=>');
          FocusScope.of(context).unfocus();
        }
        print('_keyboardVisible=-=>' + _keyboardVisible.toString());
      });
    });

    getproductData();
    // getFilteredProducts();
  }

  getproductData() async {
    productsList.clear();
    searchProductsList.clear();
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('new_products/products');
    // FirebaseDatabase.instance.ref().child('products');

    databaseReference.once().then((snapshot) {
      setState(() {
        productsList = snapshot.snapshot.value as List;
        searchProductsList = snapshot.snapshot.value as List;
        isLoaded = true;
      });

      var jsonData = productsList[1]['category'];
      print('jsonDataList=-=>' + productsList.toString());
      print('jsonData=-=>' + jsonData.toString());
    });
  }

  getFilteredProducts() async {
    productsList = [];
    searchProductsList = [];
    filteredList = [];
    setState(() {
      isLoaded = false;
    });

    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('new_products/products');
    // FirebaseDatabase.instance.ref().child('products');

    databaseReference.once().then((snapshot) {
      setState(() {
        productsList = snapshot.snapshot.value as List;
        searchProductsList = snapshot.snapshot.value as List;
        isLoaded = true;
      });

      if (selectedFilters.isNotEmpty) {
        for (var element in productsList) {
          for (var filter in selectedFilters) {
            if (element['category'] == filter) {
              print('executes');
              setState(() {
                filteredList.add(element);
              });
            }
          }
        }

        setState(() {
          productsList = [];
          searchProductsList = [];
          productsList = filteredList;
          searchProductsList = filteredList;
        });
      }
      print('filteredList.toString()' + productsList.toString());
    });
  }

  searchDir(String cType) {
    print(cType + "<===--->");
    if (cType.trim().isNotEmpty) {
      // productsList.clear();
      productsList = [];
      searchProductsList.forEach((list) {
        setState(() {
          String brand = list['brand'];
          String categories = list['category'];
          String title = list['title'];
          if (brand.toLowerCase().contains(cType.trim().toLowerCase()) ||
              categories.toLowerCase().contains(cType.trim().toLowerCase()) ||
              title.toLowerCase().contains(cType.trim().toLowerCase())) {
            productsList.add(list);
          }
        });
        // dummyListData.add(CandidatesData());
      });
      print(cType + "%%%%%%%<===--->" + (productsList.length.toString()));
    } else {
      setState(() {
        print("length--->" + (productsList.length.toString()));
        productsList.clear();
        productsList.addAll(searchProductsList);
      });
    }
  }

  Widget buildProductsShimmer() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.40,
                  decoration: BoxDecoration(
                      // color: context.color.secondaryColor,
                      // border:
                      //     Border.all(width: 1.5, color: context.color.borderColor),
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomShimmer(
                          width: 160,
                          height: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomShimmer(
                          width: 140,
                          height: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomShimmer(
                          width: 120,
                          height: 10,
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

  Widget filterWidget(BuildContext context, var mainHeight) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Stack(
        children: [
          Container(
            height: mainHeight/2,
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: Center(
                      child: Text(
                    'Filters',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            // borderRadius:
                            //     BorderRadius.only(topLeft: Radius.circular(20)),
                          ),
                          child: ListView.builder(
                            itemCount: filterNames.length,
                            itemBuilder: (BuildContext context, int index) {
                              final filterName = filterNames[index];
                              return ListTile(
                                title: Text(
                                  filterName,
                                  style: TextStyle(
                                      fontWeight:
                                          (selectedFiltersType == filterName)
                                              ? FontWeight.w500
                                              : null,
                                      color: (selectedFiltersType == filterName)
                                          ? Colors.black
                                          : null),
                                ),
                                selected: selectedFiltersType == filterName,
                                onTap: () {
                                  // because its in modalbottomsheet
                                  stateSetter(() {
                                    selectedFiltersType = filterName;
                                    print(filterValues['Category'].toString());
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ListView.builder(
                          itemCount: filterValues[selectedFiltersType]?.length,
                          itemBuilder: (BuildContext context, int index) {
                            // if (!selectedFilters.contains(filterNames[index])) {
                            //   return Container();
                            // }
                            final value =
                                filterValues[selectedFiltersType]?[index];
                            return CheckboxListTile(
                              title: Text(value ?? ""),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.black,
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              value: selectedFilters.contains(value),
                              onChanged: (boolValue) {
                                stateSetter(() {
                                  print(boolValue);

                                  if (boolValue ?? false) {
                                    selectedFilters.add(value);
                                  } else {
                                    selectedFilters.remove(value);
                                  }
                                });
                                print(selectedFilters.toString());
                              },
                            );
                            return ListTile(
                              title: Text(value ?? ""),
                              trailing: Checkbox(
                                value: selectedFilters.contains(value),
                                onChanged: (boolValue) {
                                  stateSetter(() {
                                    print(boolValue);

                                    if (boolValue ?? false) {
                                      selectedFilters.add(value);
                                    } else {
                                      selectedFilters.remove(value);
                                    }
                                  });
                                  print(selectedFilters.toString());
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: mainHeight / 10,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          stateSetter(() {
                            selectedFilters.clear();
                            getproductData();
                          });
                          // Reset the selected filters here
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        child: Text('Apply'),
                        onPressed: () {
                          // Apply the selected filters here
                          getFilteredProducts();
                          Navigator.of(context)
                              .pop(); // Close the filter screen
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var mainHeight = MediaQuery.of(context).size.height;
    var mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      /* appBar: AppBar(
        toolbarHeight: kToolbarHeight + 90.0,
        title: Text('E-Mart'),
        centerTitle: true,
        backgroundColor: ColorAll.colorsPrimary,
      ),*/
      body: (isLoaded)
          ? Container(
              child: SizedBox(
                height: mainHeight,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.blueGrey[50],
                      height: kToolbarHeight + 120.0,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    builder: (BuildContext ctx) {
                                      return filterWidget(ctx, mainHeight);
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 10.0, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Filters',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Icon(
                                      Icons.filter_list,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'EMART',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: ColorAll.colorsPrimary,
                                fontFamily: 'Vesper Libre',
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: mainWidth,
                              height: 50,
                              margin: EdgeInsets.only(
                                top: 2.sp,
                                bottom: 14.sp,
                                left: 20,
                                right: 20,
                              ),
                              child: TextField(
                                focusNode: _focusNode,
                                textInputAction: TextInputAction.none,
                                controller: searchController,
                                cursorColor: ColorAll.colorsPrimary,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey.shade400),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: ColorAll.colorsPrimary,
                                    ),
                                  ),
                                  // border: InputBorder.none,
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.all(8),
                                  hintText:
                                      'Search by Product, Brand & more...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: Icon(Icons.search),
                                  suffixIcon: (_keyboardVisible)
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.grey.shade400,
                                          ),
                                          onPressed: () {
                                            searchController.clear();
                                            // _focusNode.unfocus();
                                            searchDir("");
                                          })
                                      : null,
                                ),
                                onChanged: (value) {
                                  searchDir(value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (productsList.isNotEmpty)
                        ? Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(
                                  bottom: 33, left: 10, right: 10),
                              itemCount: productsList.length,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetails(context, index),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 1.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        //image
                                        Container(
                                          height: 200.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                productsList[index]['thumbnail']
                                                    .toString(),
                                                // productsList[index]['category']['image']
                                                //     .toString(),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                productsList[index]['brand']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                productsList[index]['title']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Row(
                                                children: [
                                                  Text(
                                                    '\$${productsList[index]['price'].toString()}',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    '\$${productsList[index]['price'].toString()}',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color:
                                                          Colors.grey.shade500,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                '${productsList[index]['discountPercentage'].toString()}\% off',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : noDataFound(context),
                  ],
                ),
              ),
            )
          : buildProductsShimmer(),
    );
  }

/*@override
  Widget build(BuildContext context) {
    var mainHeight = MediaQuery.of(context).size.height;
    var mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 28),
        child: Column(
          children: [
            AppBar(
              title: Text('E-Mart'),
              backgroundColor: ColorAll.colorsPrimary,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Center(child: CircularProgressIndicator()),
                padding: EdgeInsets.only(bottom: 33, left: 10, right: 10),
                query: dbRef,
                itemBuilder: (context, snapshot, animation, index){
                  return InkWell(
                    onTap: (){
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(context, index),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 1.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //image
                          Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    snapshot.child('thumbnail').value.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${snapshot.child('brand').value.toString()}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  snapshot.child('title').value.toString(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      '\$${snapshot.child('price').value.toString()}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 6,),
                                    Text(
                                      '\$${snapshot.child('price').value.toString()}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey.shade500,
                                        decoration: TextDecoration. lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  '${snapshot.child('discountPercentage').value.toString()}\% off',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}
