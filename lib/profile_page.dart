
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class ProfilePage extends StatelessWidget {
  final String branchName;
  final String branchLogo;
  final int StudentEnrollmentID;

  const ProfilePage({super.key, required this.branchName, required this.branchLogo,required this.StudentEnrollmentID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(branchName),backgroundColor: Colors.blueGrey,),
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.network(branchLogo,
            width: double.infinity, height: 250,
            errorBuilder: (context, error, stackTrace) {
              return Text("Failed to load image");
            },
          ),
          SizedBox(height: 20),
          Card(color: Colors.purple.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 12,
            shadowColor: Colors.blueAccent,
            child:Padding(padding: const EdgeInsets.all(10),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          "assets/mcb/mcb.jpg",  // Local image
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Expanded(child: Column(
                      children: [
                        Text("Student Enrollment ID: ${StudentEnrollmentID.toString()}", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                        Text("Student Enrollment ID: ${StudentEnrollmentID.toString()}", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                        Text("Student Enrollment ID: ${StudentEnrollmentID.toString()}", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),

                  ],)
                      ),
                    ],
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
