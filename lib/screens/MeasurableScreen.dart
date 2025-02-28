import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MeasurableScreen extends StatefulWidget {
  @override
  _MeasurableScreenState createState() => _MeasurableScreenState();
}

class _MeasurableScreenState extends State<MeasurableScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String? _creatorId;
  Map<String, dynamic> _esgData = {};
  String? _selectedCategory;

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
        _creatorId = userDoc["creator"];
      });
      _fetchEsgData();
    }
  }

  // Fetch ESG Data from Realtime Database
  void _fetchEsgData() {
    if (_creatorId == null) return;

    _database.ref("managers/$_creatorId/esgData").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _esgData = data.map((key, value) => MapEntry(key.toString(), value));
          _selectedCategory ??= _esgData.keys.first; // Select first category by default
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Measurable Data")),
      body: _esgData.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loader if data is empty
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
                double initialValue = double.tryParse(esgDetails["Initial Value"]?.toString() ?? "0") ?? 0;
                double baselineValue = double.tryParse(esgDetails["Baseline Value"]?.toString() ?? "0") ?? 0;

                // Determine status
                String status;
                if (initialValue == 0) {
                  status = "Created";
                } else if (initialValue > 0 && initialValue < baselineValue) {
                  status = "In Progress";
                } else {
                  status = "Completed";
                }

                // Status chip color
                Color statusColor;
                switch (status) {
                  case "In Progress":
                    statusColor = Colors.orange;
                    break;
                  case "Completed":
                    statusColor = Colors.green;
                    break;
                  default:
                    statusColor = Colors.blue;
                }

                return GestureDetector(
                  onTap: () => _showDetailsPopup(context, name, esgDetails),
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
                          Text("Start: $startDate  |  End: $endDate", style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Chip(
                              label: Text(status, style: TextStyle(color: Colors.white)),
                              backgroundColor: statusColor,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            ),
                          ),
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

  // Pop-up dialog to show full ESG details
  void _showDetailsPopup(BuildContext context, String title, Map<String, dynamic> details) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text("${entry.key}: ${entry.value}", style: TextStyle(fontSize: 16)),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
