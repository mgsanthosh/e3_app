import 'package:flutter/material.dart';
import 'ApprovalsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MeasurableDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> esgData;
  final String selectedCategory;
  final String selectedSubCategory;
  final void Function(BuildContext context, String category, String name, dynamic esgDetails, String esgKey) onShowContributionPopup; // Callback function
  final void Function() onFetchEsgData; // Callback function

  MeasurableDetailsScreen({required this.esgData, required this.onShowContributionPopup, required this.selectedCategory, required this.selectedSubCategory, required this.onFetchEsgData});

  @override
  State<MeasurableDetailsScreen> createState() => _MeasurableDetailsScreenState();
}

class _MeasurableDetailsScreenState extends State<MeasurableDetailsScreen> {
  String? _creatorId;
  String? _role;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    _fetchCreatorId();
  }



  void _fetchCreatorId() async {
    if (_currentUser == null) return;

    DocumentSnapshot userDoc = await _firestore.collection("users").doc(_currentUser!.uid).get();
    if (userDoc.exists) {
      setState(() {
        _role = userDoc["role"];
        _creatorId = (_role == "MANAGER") ? _currentUser!.uid : userDoc["creator"];
      });
    }
  }

  String getStatus(Map<String, dynamic> esgDetails) {
    double initialValue = double.tryParse(esgDetails["Initial Value"]?.toString() ?? "0") ?? 0;
    double baselineValue = double.tryParse(esgDetails["Baseline Value"]?.toString() ?? "0") ?? 0;

    if (initialValue == 0) return "Created";
    if (initialValue > 0 && initialValue < baselineValue) return "In Progress";
    return "Completed";
  }

  void _redirectToApprovalsScreen(String creatorId, String role, dynamic esgDetails, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApprovalsScreen(
          creatorId: creatorId,
          role: role,
          esgDetails: esgDetails,
          category: category,
        ),
      ),
    ).then((_) {
      print("Back pressed from ApprovalsScreen");
      _handleBackFromApprovalsScreen();
    });
  }

  void _handleBackFromApprovalsScreen() {
    // Perform any state updates here
    setState(() {
      // Example: Refresh data if needed
      _fetchCreatorId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Measurable Details Data")),
      body: widget.esgData.isEmpty
          ? const Center(child: Text("No Data Available", style: TextStyle(fontSize: 16)))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.esgData.entries.map((entry) {
              final Map<String, dynamic> esgDetails = Map<String, dynamic>.from(entry.value);
              String name = esgDetails["Description"]?.toString() ?? "N/A";
              String startDate = esgDetails["Start Date"]?.toString() ?? "N/A";
              String endDate = esgDetails["Deadline"]?.toString() ?? "N/A";
              String status = getStatus(esgDetails);
              String baselineValue = esgDetails["Baseline Value"]?.toString() ?? "N/A";
              String initialValue = esgDetails["Initial Value"]?.toString() ?? "N/A";

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("Start: $startDate  |  End: $endDate", style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 10),
                      Text("Baseline Value: $baselineValue"),
                      SizedBox(height: 10),
                      Text("Current Value: $initialValue"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(status),
                            backgroundColor: status == "Completed"
                                ? Colors.green
                                : status == "In Progress"
                                ? Colors.orange
                                : Colors.grey,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          if (_role == "MANAGER")
                            ElevatedButton(
                              onPressed: () => _redirectToApprovalsScreen(_creatorId!, _role!, esgDetails, name),
                              child: Text("Approvals"),
                            )
                          else
                            ElevatedButton(
                              onPressed: () => widget.onShowContributionPopup(
                                context,
                                widget.selectedCategory, // Pass category (Map key)
                                widget.selectedSubCategory,
                                esgDetails,
                                entry.key
                              ),
                              child: Text("Contribute"),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
