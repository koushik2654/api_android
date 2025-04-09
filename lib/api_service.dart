import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Map<String, dynamic>>> fetchSchools() async {
    final url = Uri.parse('https://parentapi.myclassboard.com/api/Mobile_API_/GetAllSchools');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      );
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey("response")) {
          final List<dynamic> schoolList = jsonDecode(decodedResponse["response"]);
          return schoolList.map((e) => Map<String, dynamic>.from(e)).toList();
        } else {
          print(' Error: "response" key missing or invalid format');
          return [];
        }
      } else {
        print(' Error: HTTP ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(' Failed to fetch data: $e');
      return [];
    }
  }
}