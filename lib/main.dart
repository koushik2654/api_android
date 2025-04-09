import 'package:api/school_page.dart';
import 'package:api/school_page2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'details_page.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage()
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [ Stack(
          children: [
            SizedBox(height: 400, width: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover, alignment: Alignment.topCenter,
                child: Image.asset('assets/mcb/mcb.jpg'),
              ),
            ),
            Positioned(right: 70, top: 210,
              child: Text('Powered by',
                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                ),
              ),
            ),Positioned(right: 57, top: 235,
              child: Text('My class board',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic
                ),
              ),
            ),
          ],
        ),
          Padding(padding: EdgeInsets.all(30),),
          Text(
            "Welcome to Myclassboard Admisssion Plus",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black,
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Get.to(() => HomeScreen());
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 140, vertical: 15),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 18),
            ),
            child: Text("Select Schools"),
          ),SizedBox(height: 20),
          Text("OR",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 23,color: Colors.blueGrey),),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.to(() => HomeScreen());
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 170, vertical: 15),
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              textStyle: TextStyle(fontSize: 18),
            ),
            child: Text("Scan QR"),
          ),
        ],
      ),
    );
  }
}