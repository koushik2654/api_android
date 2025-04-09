import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:http/http.dart' as http;

class EncryptionPage2 extends StatefulWidget {
  @override
  _EncryptionPageState createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage2> {
  final key = enc.Key.fromUtf8("AI0WZVEU922NW4JX4HNKRVYGE2OST619");
  final iv = enc.IV.fromUtf8("PSBCNLAQORFKUPBZ");

  late enc.Encrypter encrypter;
  String encryptedJson = "";

  @override
  void initState() {
    super.initState();
    encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  }

  void encryptNewData(String username, String password) {
    Map<String, dynamic> newData = {
      "userName": "Corp53Schools-$username",
      "password": "9490933901",
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
    String jsonString = jsonEncode(newData);
    final encrypted = encrypter.encrypt(jsonString, iv: iv);

    setState(() {
      encryptedJson = encrypted.base64;
    });
  }
  Future<void> sendEncryptedData() async {
    final String apiUrl = "https://devparentapi.myclassboard.com/api/Mobile_API_/chkMobileLogin";
    if (encryptedJson.isEmpty) {
      print("No encrypted data available!");
      return;
    }
    Map<String, dynamic> jsonBody = {
      "data": encryptedJson,
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(jsonBody),
    );
    print(jsonEncode(jsonBody));
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      print("Data sent successfully: ${response.body}");
    } else {
      print("Failed to send data: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Encrypt New Data")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                encryptNewData("NewUser123", "SecurePass!");
              },
              child: Text("Encrypt New User Data"),
            ),
            SizedBox(height: 20),
            SelectableText("$encryptedJson", style: TextStyle(color: Colors.blue)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendEncryptedData,
              child: Text("Send Encrypted Data"),),
          ],
        ),
      ),
    );
  }
}