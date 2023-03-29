import 'package:emart/main.dart';
import 'package:flutter/material.dart';

class Orders_screen extends StatefulWidget {
  const Orders_screen({Key? key}) : super(key: key);

  @override
  State<Orders_screen> createState() => _Orders_screenState();
}

class _Orders_screenState extends State<Orders_screen> {
  @override
  Widget build(BuildContext context) {
    var mainWidth = MediaQuery.of(context).size.width;
    var mainHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: ColorAll.colorsPrimary,
        title: Text('Orders'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white, size: 35,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        height: 100,
        padding: EdgeInsets.only(left: 14, right: 14),
        child: Card(
          // color: Colors.green,
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),),
          margin: EdgeInsets.symmetric(vertical: 0.8),
          elevation: 0,
          child: Center(
            child: ListTile(
              onTap: () {},
              minLeadingWidth: 0,
              leading: SizedBox(
                height: double.infinity,
                child: ClipRRect(
                  // borderRadius: BorderRadius.all(Radius.circular(8.0),),
                  child: Image.asset('assets/images/electronic.png', scale: 1,),
                ),
              ),
              title: Text('Delivered'),
              subtitle: Text('Delivered on 19 june'),
              trailing: ImageIcon(
                AssetImage(
                  'assets/icons/right.png',
                ),
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
