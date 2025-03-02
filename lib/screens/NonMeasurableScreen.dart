import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e3_app/screens/MeasurableDetailsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'NonMeasurableDetailsScreen.dart';

class NonMeasurableScreen extends StatefulWidget {
  const NonMeasurableScreen({super.key});

  @override
  State<NonMeasurableScreen> createState() => _NonMeasurableScreenState();
}

class _NonMeasurableScreenState extends State<NonMeasurableScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String selectedCategory = "NA";
  String selectedSubcategory = "NA";

  String? _creatorId;
  String? _role;
  Map<String, dynamic> _esgData = {};
  String? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCreatorId();
  }

  // Fetch creatorId from Firestore
  void _fetchCreatorId() async {
    if (_currentUser == null) return;

    DocumentSnapshot userDoc = await _firestore.collection("users").doc(_currentUser!.uid).get();
    if (userDoc.exists) {
      setState(() {
        _role = userDoc["role"];
      });
      setState(() {
        if(userDoc["role"] == "MANAGER") {
          _creatorId = _currentUser!.uid;
        } else {
          _creatorId = userDoc["creator"];
        }
      });
      _fetchEsgData();
    }
  }

  // Fetch ESG Data from Realtime Database
  void _fetchEsgData() {
    print("FECTHING THE FETCH ESG DATA " + _esgData.toString());
    if (_creatorId == null) return;
    _database.ref("managers/$_creatorId/esgData").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _esgData = data.map((key, value) => MapEntry(key.toString(), value));
          _selectedCategory ??= _esgData.keys.first; // Select first category by default
          _isLoading = false;
        });
      }
    });
  }

  void _redirectToMeasurableDetailsScreen(Map<String, dynamic> esgData, String subcategory) {
    print("The Sub Category " + subcategory);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeasurableDetailsScreen(esgData: esgData, selectedCategory: _selectedCategory!,selectedSubCategory: subcategory, onFetchEsgData: _fetchEsgData, onShowContributionPopup: (BuildContext context, String category, String name, esgDetails, String esgKey) {  },),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Non Measurable Data")),
      body: _esgData.isEmpty
          ? Center(child: Container(child: Text("No Data Available"),)) // Show loader if data is empty
          : Column(
        children: [
          // Tabs for categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _esgData.keys.map((category) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ChoiceChip(
                    label: Text(category, style: TextStyle(fontSize: 16)),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.blue.shade200,
                  ),
                );
              }).toList(),
            ),
          ),

          // Display ESG Data in Cards
          Expanded(
            child: _selectedCategory == null
                ? Center(child: Text("No data available"))
                : ListView(
              padding: EdgeInsets.all(10),
              children: (_esgData[_selectedCategory] as Map<dynamic, dynamic>).entries.map((entry) {
                final Map<String, dynamic> esgDetails = Map<String, dynamic>.from(entry.value);
                String name = entry.key.toString();
                String startDate = esgDetails["Start Date"]?.toString() ?? "N/A";
                String endDate = esgDetails["Deadline"]?.toString() ?? "N/A";
                // String status = getStatus(esgDetails);
                String baselineValue = esgDetails["Baseline Value"]?.toString() ?? "N/A";
                String initialValue = esgDetails["Initial Value"]?.toString() ?? "N/A";

                return GestureDetector(
                  onTap: () => {
                    _redirectToMeasurableDetailsScreen(esgDetails, name)
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("${esgDetails.length} Subcategories"),

                          // Text("Start: $startDate  |  End: $endDate", style: TextStyle(color: Colors.grey[700])),
                          // SizedBox(height: 10),
                          // Text("Baseline Value: $baselineValue"),
                          // SizedBox(height: 10),
                          // Text("Current Value: $initialValue"),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Chip(
                          //       label: Text(status),
                          //       backgroundColor: status == "Completed"
                          //           ? Colors.green
                          //           : status == "In Progress"
                          //           ? Colors.orange
                          //           : Colors.grey,
                          //       labelStyle: TextStyle(color: Colors.white),
                          //     ),
                          //     _role == "MANAGER" ? ElevatedButton(
                          //       onPressed: () => _redirectToApprovalsScreen(_creatorId!, _role!, esgDetails, name),
                          //       child: Text("Approvals"),
                          //     ) :ElevatedButton(
                          //       onPressed: () => _showContributionPopup(context, _selectedCategory!, name, esgDetails),
                          //       child: Text("Contribute"),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
