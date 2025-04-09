import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'api_service.dart';
import 'details_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> schoolDetails = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredSchools = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_filterSchools);
  }

  Future<void> fetchData() async {
    final schools = await apiService.fetchSchools();
    setState(() {
      schoolDetails = schools;
      filteredSchools = List.from(schoolDetails);
      isLoading = false;
    });
  }

  void _filterSchools() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredSchools = List.from(schoolDetails);
      } else {
        filteredSchools = schoolDetails
            .where((school) =>
            school["SchoolName"].toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schools List',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 35),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search for Schools",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator()) : schoolDetails.isEmpty
                  ? Center(child: Text("No schools available.")) : ListView.builder(
                itemCount: filteredSchools.length,
                itemBuilder: (context, index) {
                  final school = filteredSchools[index];
                  return ListTile(
                    title: Text(school["SchoolName"] ?? "No Name"),
                    trailing: Icon(Icons.arrow_forward),
                    focusColor: Colors.blue,
                    onTap: () {
                      Get.to(() => DetailsPage(
                        schoolName: school["SchoolName"],
                        schoolId: school["SchoolID"],
                        appName: school["AppName"],
                        appLogoUrl: school["AppLogoUrl"],
                      ));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}