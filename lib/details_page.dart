import 'dart:convert';
import 'package:api/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    super.key,
    required this.schoolId,
    this.appName,
    this.schoolName,
    this.appLogoUrl,
  });

  final int? schoolId;
  final String? schoolName;
  final String? appName;
  final String? appLogoUrl;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    final key = enc.Key.fromUtf8("AI0WZVEU922NW4JX4HNKRVYGE2OST619");
    final iv = enc.IV.fromUtf8("PSBCNLAQORFKUPBZ");
    String _encryptData(String username, String password) {
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

      Map<String, dynamic> payload = {
        "userName": "Corp53Schools-$username",
        "password": password,
        "userGUID": "",
        "device_type": "{androidId: U1UGS34.23-82-2-7}",
        "deviceModel": "A",
        "device_id": "59774f0918e1ccb1b8d898021d8dfcba07bf88f6",
        "device_token": "dRz9gvyhQUmo4JvEy-7xBy:APA91bFL1CjdcRyYQuagRik4lyw97ckkmS5aSylkoiVPzyvbIbpVq3zidaPihw1IkbtxAqCxzNxEF9tKZ32R51I6u-Wt4vtV1yEMo7kPa1UY7NSbhzMXgus",
        "usercurrentversion": "2.4.9",
        "packagename": "com.mcb.myclassboard.activity",
        "apikey": "AI0WZVEU922NW4JX4HNKRVYGE2OST619",
        "organisationID": 24
      };

      String jsonString = jsonEncode(payload);
      final encrypted = encrypter.encrypt(jsonString, iv: iv);
      return encrypted.base64;
    }
    Future<void> _sendEncryptedData() async {
      if (!_formKey.currentState!.validate()) return;

      String apiUrl = "https://devparentapi.myclassboard.com/api/Mobile_API_/chkMobileLogin";
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      String encryptedData = _encryptData(username, password);

      Map<String, dynamic> jsonBody = {
        "data": encryptedData,
      };
      try {
        final response = await http.post(Uri.parse(apiUrl),
          headers: {
          "Content-Type": "application/json",
            "Accept": "application/json",},
          body: jsonEncode(jsonBody),
        );
        print("Sent JSON: ${jsonEncode(jsonBody)}");
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData.containsKey("response")) {
            final decodedResponse = jsonDecode(responseData["response"]);

            if (decodedResponse.containsKey("StudentData")) {
              final studentData = decodedResponse["StudentData"];
              String branchName = studentData["BranchName"] ?? "No Branch Name";
              String branchLogo = studentData["BranchLogo_App"] ?? "";
              int StudentEnrollmentID = (studentData["StudentEnrollmentID"] is int)
                  ? studentData["StudentEnrollmentID"]
                  : int.tryParse(studentData["StudentEnrollmentID"].toString()) ?? 0;

              Get.to(() => ProfilePage(branchName: branchName, branchLogo: branchLogo,StudentEnrollmentID:StudentEnrollmentID));
            } else {
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                SnackBar(content: Text("Login Successful, but no StudentData found!")),
              );
            }
          } else {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Login Successful, but missing 'response' data!")),
            );
          }
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("Login Failed: ${response.body}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Login Page and details")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (appLogoUrl != null && appLogoUrl!.isNotEmpty)
                Image.network(
                  appLogoUrl!, width: 450, height: 300,
                  fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                    return Text("Image failed to load",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    );
                  },
                )
              else
                Text("No Image Available"),
              SizedBox(height: 30),
              Text(
                schoolName ?? "No School Name",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.purple),),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Enter your Username",
                  border: OutlineInputBorder(),),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Username cannot be empty";
                  return null;
                },),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Password cannot be empty";
                  return null;
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _sendEncryptedData();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 140, vertical: 15),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}